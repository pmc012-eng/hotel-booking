const { query } = require('../config/db');

class RoomModel {
  /**
   * Lấy danh sách tất cả phòng của một khách sạn
   */
  static async findByHotelId(hotelId) {
    const sql = `
      SELECT 
        r.id,
        r.hotel_id,
        r.room_type_id,
        r.room_number,
        r.status,
        rt.name as room_type_name,
        rt.capacity,
        rt.price,
        rt.image_url,
        rt.amenities
      FROM rooms r
      JOIN room_types rt ON r.room_type_id = rt.id
      WHERE r.hotel_id = ?
      ORDER BY r.room_number ASC
    `;
    const rows = await query(sql, [hotelId]);
    return rows.map((r) => ({
      ...r,
      amenities: typeof r.amenities === 'string' ? JSON.parse(r.amenities || '[]') : r.amenities || [],
    }));
  }

  /**
   * Lấy danh sách loại phòng (Room Types) của khách sạn
   */
  static async findRoomTypesByHotelId(hotelId) {
    const sql = `
      SELECT 
        rt.*,
        COUNT(r.id) as total_rooms,
        SUM(CASE WHEN r.status = 'AVAILABLE' THEN 1 ELSE 0 END) as available_rooms_count
      FROM room_types rt
      LEFT JOIN rooms r ON rt.id = r.room_type_id
      WHERE rt.hotel_id = ?
      GROUP BY rt.id
      ORDER BY rt.price ASC
    `;
    const rows = await query(sql, [hotelId]);
    return rows.map((rt) => ({
      ...rt,
      amenities: typeof rt.amenities === 'string' ? JSON.parse(rt.amenities || '[]') : rt.amenities || [],
    }));
  }

  /**
   * API CỐT LÕI: Tìm danh sách phòng còn trống theo khoảng ngày check_in và check_out
   * Thuật toán: Một phòng khả dụng khi:
   * 1. Trạng thái r.status = 'AVAILABLE'
   * 2. Không tồn tại booking nào (khác CANCELLED) có: check_in < requestedCheckOut AND check_out > requestedCheckIn
   */
  static async findAvailableRooms(hotelId, { checkIn, checkOut, roomTypeId = null }) {
    const conditions = [
      'r.hotel_id = ?',
      "r.status = 'AVAILABLE'",
      `r.id NOT IN (
        SELECT b.room_id 
        FROM bookings b 
        WHERE b.status != 'CANCELLED'
          AND b.check_in < ? 
          AND b.check_out > ?
      )`,
    ];
    const params = [hotelId, checkOut, checkIn];

    if (roomTypeId) {
      conditions.push('r.room_type_id = ?');
      params.push(roomTypeId);
    }

    const sql = `
      SELECT 
        r.id,
        r.hotel_id,
        r.room_type_id,
        r.room_number,
        r.status,
        rt.name as room_type_name,
        rt.description as room_type_description,
        rt.capacity,
        rt.price,
        rt.image_url,
        rt.amenities,
        h.name as hotel_name,
        h.address as hotel_address,
        h.city as hotel_city
      FROM rooms r
      JOIN room_types rt ON r.room_type_id = rt.id
      JOIN hotels h ON r.hotel_id = h.id
      WHERE ${conditions.join(' AND ')}
      ORDER BY rt.price ASC, r.room_number ASC
    `;

    const rows = await query(sql, params);
    return rows.map((r) => ({
      ...r,
      amenities: typeof r.amenities === 'string' ? JSON.parse(r.amenities || '[]') : r.amenities || [],
    }));
  }

  /**
   * Lấy chi tiết 1 phòng theo ID
   */
  static async findById(id) {
    const sql = `
      SELECT 
        r.id,
        r.hotel_id,
        r.room_type_id,
        r.room_number,
        r.status,
        rt.name as room_type_name,
        rt.description as room_type_description,
        rt.capacity,
        rt.price,
        rt.image_url,
        rt.amenities,
        h.name as hotel_name,
        h.address as hotel_address,
        h.city as hotel_city
      FROM rooms r
      JOIN room_types rt ON r.room_type_id = rt.id
      JOIN hotels h ON r.hotel_id = h.id
      WHERE r.id = ?
      LIMIT 1
    `;
    const [row] = await query(sql, [id]);
    if (!row) return null;
    return {
      ...row,
      amenities: typeof row.amenities === 'string' ? JSON.parse(row.amenities || '[]') : row.amenities || [],
    };
  }

  /**
   * Thêm phòng mới (ADMIN)
   */
  static async create({ hotelId, roomTypeId, roomNumber, status = 'AVAILABLE' }) {
    const result = await query(
      `INSERT INTO rooms (hotel_id, room_type_id, room_number, status) VALUES (?, ?, ?, ?)`,
      [hotelId, roomTypeId, roomNumber, status]
    );
    return this.findById(result.insertId);
  }

  /**
   * Cập nhật phòng (ADMIN)
   */
  static async update(id, { roomNumber, roomTypeId, status }) {
    await query(
      `UPDATE rooms SET 
        room_number = COALESCE(?, room_number),
        room_type_id = COALESCE(?, room_type_id),
        status = COALESCE(?, status)
      WHERE id = ?`,
      [roomNumber ?? null, roomTypeId ?? null, status ?? null, id]
    );
    return this.findById(id);
  }

  /**
   * Xóa phòng (ADMIN)
   */
  static async delete(id) {
    const result = await query('DELETE FROM rooms WHERE id = ?', [id]);
    return result.affectedRows > 0;
  }

  /**
   * Thêm loại phòng mới (ADMIN)
   */
  static async createRoomType({ hotelId, name, description, capacity, price, imageUrl, amenities = [] }) {
    const result = await query(
      `INSERT INTO room_types (hotel_id, name, description, capacity, price, image_url, amenities) 
       VALUES (?, ?, ?, ?, ?, ?, ?)`,
      [
        hotelId,
        name,
        description,
        capacity,
        price,
        imageUrl || '/uploads/room_1.jpg',
        JSON.stringify(amenities),
      ]
    );
    const [rt] = await query('SELECT * FROM room_types WHERE id = ?', [result.insertId]);
    return {
      ...rt,
      amenities: typeof rt.amenities === 'string' ? JSON.parse(rt.amenities || '[]') : rt.amenities || [],
    };
  }
}

module.exports = RoomModel;
