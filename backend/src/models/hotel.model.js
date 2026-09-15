const { query } = require('../config/db');

class HotelModel {
  /**
   * Lấy danh sách khách sạn có tìm kiếm, lọc và phân trang
   */
  static async findAll({
    search = '',
    city = '',
    star = null,
    minPrice = null,
    maxPrice = null,
    sortBy = 'rating_desc',
    page = 1,
    limit = 10,
  }) {
    const offset = (page - 1) * limit;
    const conditions = [];
    const params = [];

    if (search && search.trim() !== '') {
      conditions.push('(h.name LIKE ? OR h.address LIKE ? OR h.city LIKE ?)');
      const searchParam = `%${search.trim()}%`;
      params.push(searchParam, searchParam, searchParam);
    }

    if (city && city.trim() !== '') {
      conditions.push('h.city = ?');
      params.push(city.trim());
    }

    if (star !== null && star !== undefined && star !== '') {
      conditions.push('h.star = ?');
      params.push(parseInt(star, 10));
    }

    const whereClause = conditions.length > 0 ? `WHERE ${conditions.join(' AND ')}` : '';

    // Sắp xếp
    let orderClause = 'ORDER BY h.id DESC';
    if (sortBy === 'price_asc') {
      orderClause = 'ORDER BY min_price ASC';
    } else if (sortBy === 'price_desc') {
      orderClause = 'ORDER BY min_price DESC';
    } else if (sortBy === 'rating_desc') {
      orderClause = 'ORDER BY h.rating DESC, h.id DESC';
    }

    // Điều kiện lọc theo giá phòng
    let havingClause = '';
    const havingConditions = [];
    const havingParams = [];

    if (minPrice !== null && minPrice !== undefined && minPrice !== '') {
      havingConditions.push('min_price >= ?');
      havingParams.push(parseFloat(minPrice));
    }
    if (maxPrice !== null && maxPrice !== undefined && maxPrice !== '') {
      havingConditions.push('min_price <= ?');
      havingParams.push(parseFloat(maxPrice));
    }

    if (havingConditions.length > 0) {
      havingClause = `HAVING ${havingConditions.join(' AND ')}`;
    }

    // Câu lệnh lấy dữ liệu khách sạn kèm ảnh chính và giá phòng thấp nhất
    const sql = `
      SELECT 
        h.id,
        h.name,
        h.description,
        h.address,
        h.city,
        h.star,
        h.rating,
        h.created_at,
        COALESCE(
          (SELECT image_url FROM hotel_images WHERE hotel_id = h.id ORDER BY is_primary DESC, id ASC LIMIT 1),
          '/uploads/hotel_1.jpg'
        ) as primary_image,
        COALESCE(MIN(rt.price), h.min_price, 0) as min_price,
        COUNT(DISTINCT r.id) as review_count
      FROM hotels h
      LEFT JOIN room_types rt ON h.id = rt.hotel_id
      LEFT JOIN reviews r ON h.id = r.hotel_id
      ${whereClause}
      GROUP BY h.id
      ${havingClause}
      ${orderClause}
      LIMIT ? OFFSET ?
    `;

    // Query đếm tổng số bản ghi
    const countSql = havingClause
      ? `SELECT COUNT(*) as total FROM (
           SELECT h.id, COALESCE(MIN(rt.price), h.min_price, 0) as min_price
           FROM hotels h
           LEFT JOIN room_types rt ON h.id = rt.hotel_id
           ${whereClause}
           GROUP BY h.id
           ${havingClause}
         ) sub`
      : `SELECT COUNT(DISTINCT h.id) as total FROM hotels h ${whereClause}`;

    const finalParams = [...params, ...havingParams, parseInt(limit, 10), parseInt(offset, 10)];
    const countParams = [...params, ...havingParams];

    const [rows, countRows] = await Promise.all([
      query(sql, finalParams),
      query(countSql, countParams),
    ]);

    const total = countRows && countRows[0] ? countRows[0].total : 0;

    return {
      items: rows,
      total,
    };
  }

  /**
   * Lấy danh sách khách sạn nổi bật (Featured Hotels cho trang Home)
   */
  static async findFeatured(limit = 6) {
    const sql = `
      SELECT 
        h.id,
        h.name,
        h.description,
        h.address,
        h.city,
        h.star,
        h.rating,
        COALESCE(
          (SELECT image_url FROM hotel_images WHERE hotel_id = h.id ORDER BY is_primary DESC, id ASC LIMIT 1),
          '/uploads/hotel_1.jpg'
        ) as primary_image,
        COALESCE(MIN(rt.price), h.min_price, 0) as min_price,
        COUNT(DISTINCT r.id) as review_count
      FROM hotels h
      LEFT JOIN room_types rt ON h.id = rt.hotel_id
      LEFT JOIN reviews r ON h.id = r.hotel_id
      GROUP BY h.id
      ORDER BY h.rating DESC, h.star DESC
      LIMIT ?
    `;
    return query(sql, [parseInt(limit, 10)]);
  }

  /**
   * Lấy chi tiết 1 khách sạn kèm ảnh, loại phòng và tiện nghi
   */
  static async findById(id) {
    const hotelSql = `
      SELECT 
        h.id,
        h.name,
        h.description,
        h.address,
        h.city,
        h.star,
        h.rating,
        h.created_at,
        COALESCE(MIN(rt.price), h.min_price, 0) as min_price,
        COUNT(DISTINCT r.id) as review_count
      FROM hotels h
      LEFT JOIN room_types rt ON h.id = rt.hotel_id
      LEFT JOIN reviews r ON h.id = r.hotel_id
      WHERE h.id = ?
      GROUP BY h.id
      LIMIT 1
    `;

    const [hotel] = await query(hotelSql, [id]);
    if (!hotel) return null;

    // Lấy toàn bộ danh sách ảnh
    const images = await query(
      'SELECT id, image_url, is_primary FROM hotel_images WHERE hotel_id = ? ORDER BY is_primary DESC, id ASC',
      [id]
    );

    // Lấy các loại phòng của khách sạn
    const roomTypes = await query(
      'SELECT id, name, description, capacity, price, image_url, amenities FROM room_types WHERE hotel_id = ? ORDER BY price ASC',
      [id]
    );

    // Parse JSON amenities trong từng loại phòng
    const formattedRoomTypes = roomTypes.map((rt) => ({
      ...rt,
      amenities: typeof rt.amenities === 'string' ? JSON.parse(rt.amenities || '[]') : rt.amenities || [],
    }));

    return {
      ...hotel,
      images: images.map((img) => img.image_url),
      roomTypes: formattedRoomTypes,
    };
  }

  /**
   * Tạo khách sạn mới (ADMIN)
   */
  static async create({ name, description, address, city, star = 4, rating = 5.0, minPrice = 0, images = [] }) {
    const priceVal = parseFloat(minPrice) || 0;
    const result = await query(
      `INSERT INTO hotels (name, description, address, city, star, rating, min_price) VALUES (?, ?, ?, ?, ?, ?, ?)`,
      [name, description, address, city, star, rating, priceVal]
    );
    const hotelId = result.insertId;

    // Chèn ảnh
    if (Array.isArray(images) && images.length > 0) {
      for (let i = 0; i < images.length; i++) {
        await query(
          `INSERT INTO hotel_images (hotel_id, image_url, is_primary) VALUES (?, ?, ?)`,
          [hotelId, images[i], i === 0 ? 1 : 0]
        );
      }
    } else {
      // Ảnh mặc định
      await query(
        `INSERT INTO hotel_images (hotel_id, image_url, is_primary) VALUES (?, ?, ?)`,
        [hotelId, '/uploads/hotel_1.jpg', 1]
      );
    }

    // Nếu có giá khởi tạo > 0, tự động tạo 1 loại phòng tiêu chuẩn và phòng đầu tiên để khách có thể đặt được ngay
    if (priceVal > 0) {
      try {
        const rtResult = await query(
          `INSERT INTO room_types (hotel_id, name, description, capacity, price, image_url, amenities) 
           VALUES (?, ?, ?, ?, ?, ?, ?)`,
          [
            hotelId,
            'Phòng Tiêu Chuẩn (Standard)',
            'Phòng tiêu chuẩn tiện nghi đầy đủ, view thoáng mát',
            2,
            priceVal,
            '/uploads/room_1.jpg',
            JSON.stringify(['Wifi miễn phí', 'Điều hòa 2 chiều', 'TV thông minh', 'Bình nước nóng']),
          ]
        );
        const roomTypeId = rtResult.insertId;
        await query(
          `INSERT INTO rooms (hotel_id, room_type_id, room_number, status) VALUES (?, ?, ?, ?)`,
          [hotelId, roomTypeId, '101', 'AVAILABLE']
        );
      } catch (err) {
        console.error('Lỗi khi tạo phòng mặc định cho khách sạn:', err.message);
      }
    }

    return this.findById(hotelId);
  }

  /**
   * Cập nhật thông tin khách sạn (ADMIN)
   */
  static async update(id, { name, description, address, city, star, rating, minPrice, images }) {
    const priceVal = minPrice !== undefined ? parseFloat(minPrice) : null;
    await query(
      `UPDATE hotels SET 
        name = COALESCE(?, name),
        description = COALESCE(?, description),
        address = COALESCE(?, address),
        city = COALESCE(?, city),
        star = COALESCE(?, star),
        rating = COALESCE(?, rating),
        min_price = COALESCE(?, min_price)
      WHERE id = ?`,
      [name ?? null, description ?? null, address ?? null, city ?? null, star ?? null, rating ?? null, priceVal, id]
    );

    if (Array.isArray(images) && images.length > 0) {
      await query('DELETE FROM hotel_images WHERE hotel_id = ?', [id]);
      for (let i = 0; i < images.length; i++) {
        await query(
          `INSERT INTO hotel_images (hotel_id, image_url, is_primary) VALUES (?, ?, ?)`,
          [id, images[i], i === 0 ? 1 : 0]
        );
      }
    }

    return this.findById(id);
  }

  /**
   * Xóa khách sạn (ADMIN)
   */
  static async delete(id) {
    const result = await query('DELETE FROM hotels WHERE id = ?', [id]);
    return result.affectedRows > 0;
  }
}

module.exports = HotelModel;
