const { query, pool } = require('../config/db');

class BookingModel {
  /**
   * Kiểm tra xem 1 phòng có trống trong khoảng ngày checkIn -> checkOut hay không
   */
  static async isRoomAvailable(roomId, checkIn, checkOut) {
    const sql = `
      SELECT COUNT(*) as count 
      FROM bookings 
      WHERE room_id = ? 
        AND status != 'CANCELLED'
        AND check_in < ? 
        AND check_out > ?
    `;
    const rows = await query(sql, [roomId, checkOut, checkIn]);
    return rows[0].count === 0;
  }

  /**
   * Tạo booking mới (Có bảo vệ chống trùng lặp và tính toán giá từ Backend)
   */
  static async create({
    userId,
    roomId,
    checkIn,
    checkOut,
    guestName,
    guestPhone,
    guestEmail,
    paymentMethod = 'PAY_AT_HOTEL',
  }) {
    // 1. Lấy thông tin phòng và giá niêm yết từ CSDL
    const roomSql = `
      SELECT 
        r.id,
        r.hotel_id,
        r.room_number,
        r.status as room_status,
        rt.name as room_type_name,
        rt.price as price_per_night,
        h.name as hotel_name,
        h.address as hotel_address,
        h.city as hotel_city
      FROM rooms r
      JOIN room_types rt ON r.room_type_id = rt.id
      JOIN hotels h ON r.hotel_id = h.id
      WHERE r.id = ?
      LIMIT 1
    `;
    const [room] = await query(roomSql, [roomId]);
    if (!room) {
      throw new Error('Phòng được chọn không tồn tại trong hệ thống!');
    }

    if (room.room_status !== 'AVAILABLE') {
      throw new Error('Phòng này hiện đang được bảo trì, vui lòng chọn phòng khác!');
    }

    // 2. Kiểm tra trùng phòng
    const isAvailable = await this.isRoomAvailable(roomId, checkIn, checkOut);
    if (!isAvailable) {
      throw new Error('Rất tiếc, phòng này vừa được người khác đặt trong khoảng thời gian đã chọn!');
    }

    // 3. Tính số đêm và tổng tiền tự động ở Backend (Không phụ thuộc giá từ Client)
    const checkInDate = new Date(checkIn);
    const checkOutDate = new Date(checkOut);
    const diffTime = checkOutDate.getTime() - checkInDate.getTime();
    const numberOfNights = Math.max(1, Math.round(diffTime / (1000 * 60 * 60 * 24)));

    const totalPrice = parseFloat(room.price_per_night) * numberOfNights;

    // 4. Tạo mã đặt phòng duy nhất
    const randomSuffix = Math.floor(1000 + Math.random() * 9000);
    const bookingCode = `HB-${new Date().getFullYear()}-${randomSuffix}`;

    // 5. Chèn vào CSDL
    const insertSql = `
      INSERT INTO bookings (
        booking_code,
        user_id,
        room_id,
        check_in,
        check_out,
        guest_name,
        guest_phone,
        guest_email,
        total_price,
        status,
        payment_method,
        payment_status
      ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, 'CONFIRMED', ?, 'UNPAID')
    `;

    const result = await query(insertSql, [
      bookingCode,
      userId,
      roomId,
      checkIn,
      checkOut,
      guestName.trim(),
      guestPhone.trim(),
      guestEmail.trim().toLowerCase(),
      totalPrice,
      paymentMethod,
    ]);

    return this.findById(result.insertId);
  }

  /**
   * Lấy danh sách booking của người dùng
   */
  static async findByUserId(userId, status = null) {
    const conditions = ['b.user_id = ?'];
    const params = [userId];

    if (status) {
      conditions.push('b.status = ?');
      params.push(status);
    }

    const sql = `
      SELECT 
        b.*,
        r.room_number,
        rt.name as room_type_name,
        rt.price as price_per_night,
        h.id as hotel_id,
        h.name as hotel_name,
        h.address as hotel_address,
        h.city as hotel_city,
        h.star as hotel_star,
        COALESCE(
          (SELECT image_url FROM hotel_images WHERE hotel_id = h.id ORDER BY is_primary DESC, id ASC LIMIT 1),
          '/uploads/hotel_1.jpg'
        ) as hotel_image,
        DATEDIFF(b.check_out, b.check_in) as number_of_nights
      FROM bookings b
      JOIN rooms r ON b.room_id = r.id
      JOIN room_types rt ON r.room_type_id = rt.id
      JOIN hotels h ON r.hotel_id = h.id
      WHERE ${conditions.join(' AND ')}
      ORDER BY b.created_at DESC
    `;

    return query(sql, params);
  }

  /**
   * Lấy chi tiết 1 booking theo ID
   */
  static async findById(id) {
    const sql = `
      SELECT 
        b.*,
        r.room_number,
        rt.name as room_type_name,
        rt.price as price_per_night,
        rt.image_url as room_image,
        rt.amenities as room_amenities,
        h.id as hotel_id,
        h.name as hotel_name,
        h.address as hotel_address,
        h.city as hotel_city,
        h.star as hotel_star,
        COALESCE(
          (SELECT image_url FROM hotel_images WHERE hotel_id = h.id ORDER BY is_primary DESC, id ASC LIMIT 1),
          '/uploads/hotel_1.jpg'
        ) as hotel_image,
        DATEDIFF(b.check_out, b.check_in) as number_of_nights
      FROM bookings b
      JOIN rooms r ON b.room_id = r.id
      JOIN room_types rt ON r.room_type_id = rt.id
      JOIN hotels h ON r.hotel_id = h.id
      WHERE b.id = ?
      LIMIT 1
    `;
    const [booking] = await query(sql, [id]);
    if (!booking) return null;

    return {
      ...booking,
      room_amenities:
        typeof booking.room_amenities === 'string'
          ? JSON.parse(booking.room_amenities || '[]')
          : booking.room_amenities || [],
    };
  }

  /**
   * Hủy đặt phòng
   */
  static async cancel(id, userId, userRole = 'USER') {
    const booking = await this.findById(id);
    if (!booking) {
      throw new Error('Không tìm thấy đơn đặt phòng với ID này!');
    }

    // Kiểm tra quyền sở hữu
    if (userRole !== 'ADMIN' && booking.user_id !== userId) {
      throw new Error('Bạn không có quyền hủy đơn đặt phòng của người khác!');
    }

    if (booking.status === 'CANCELLED') {
      throw new Error('Đơn đặt phòng này đã được hủy trước đó!');
    }

    if (booking.status === 'COMPLETED') {
      throw new Error('Không thể hủy đơn đặt phòng đã hoàn thành lưu trú!');
    }

    // Cập nhật trạng thái thành CANCELLED
    await query(`UPDATE bookings SET status = 'CANCELLED' WHERE id = ?`, [id]);
    return this.findById(id);
  }

  /**
   * Lấy tất cả bookings (Dành cho Admin)
   */
  static async findAll({ status = null, page = 1, limit = 20 } = {}) {
    const conditions = [];
    const params = [];

    if (status && status !== 'ALL') {
      conditions.push('b.status = ?');
      params.push(status);
    }

    const whereClause = conditions.length > 0 ? `WHERE ${conditions.join(' AND ')}` : '';

    const countSql = `SELECT COUNT(*) as total FROM bookings b ${whereClause}`;
    const [countResult] = await query(countSql, params);
    const total = countResult ? countResult.total : 0;

    const offset = (page - 1) * limit;
    const sql = `
      SELECT 
        b.*,
        u.name as user_name,
        u.email as user_email,
        r.room_number,
        rt.name as room_type_name,
        rt.price as price_per_night,
        h.id as hotel_id,
        h.name as hotel_name,
        h.address as hotel_address,
        h.city as hotel_city,
        h.star as hotel_star,
        COALESCE(
          (SELECT image_url FROM hotel_images WHERE hotel_id = h.id ORDER BY is_primary DESC, id ASC LIMIT 1),
          '/uploads/hotel_1.jpg'
        ) as hotel_image,
        DATEDIFF(b.check_out, b.check_in) as number_of_nights
      FROM bookings b
      JOIN users u ON b.user_id = u.id
      JOIN rooms r ON b.room_id = r.id
      JOIN room_types rt ON r.room_type_id = rt.id
      JOIN hotels h ON r.hotel_id = h.id
      ${whereClause}
      ORDER BY b.created_at DESC
      LIMIT ? OFFSET ?
    `;

    const rows = await query(sql, [...params, limit, offset]);
    return {
      total,
      page,
      limit,
      totalPages: Math.ceil(total / limit),
      bookings: rows,
    };
  }

  /**
   * Cập nhật trạng thái booking (Admin)
   */
  static async updateStatus(id, newStatus) {
    const validStatuses = ['CONFIRMED', 'COMPLETED', 'CANCELLED'];
    if (!validStatuses.includes(newStatus)) {
      throw new Error(`Trạng thái không hợp lệ (${validStatuses.join(', ')})`);
    }

    const booking = await this.findById(id);
    if (!booking) {
      throw new Error('Không tìm thấy đơn đặt phòng!');
    }

    await query(`UPDATE bookings SET status = ? WHERE id = ?`, [newStatus, id]);
    return this.findById(id);
  }

  /**
   * Lấy thống kê tổng quan (Admin Dashboard)
   */
  static async getStatistics() {
    // 1. Doanh thu
    const [revenueRow] = await query(`
      SELECT 
        COALESCE(SUM(total_price), 0) as total_revenue
      FROM bookings 
      WHERE status IN ('CONFIRMED', 'COMPLETED')
    `);

    // 2. Thống kê bookings
    const [bookingStats] = await query(`
      SELECT 
        COUNT(*) as total_bookings,
        SUM(CASE WHEN status = 'CONFIRMED' THEN 1 ELSE 0 END) as confirmed_bookings,
        SUM(CASE WHEN status = 'COMPLETED' THEN 1 ELSE 0 END) as completed_bookings,
        SUM(CASE WHEN status = 'CANCELLED' THEN 1 ELSE 0 END) as cancelled_bookings
      FROM bookings
    `);

    // 3. Khách sạn & Phòng
    const [hotelCount] = await query(`SELECT COUNT(*) as total_hotels FROM hotels`);
    const [roomCount] = await query(`
      SELECT 
        COUNT(*) as total_rooms,
        SUM(CASE WHEN status = 'AVAILABLE' THEN 1 ELSE 0 END) as available_rooms,
        SUM(CASE WHEN status = 'MAINTENANCE' THEN 1 ELSE 0 END) as maintenance_rooms
      FROM rooms
    `);

    // 4. Người dùng
    const [userCount] = await query(`SELECT COUNT(*) as total_users FROM users WHERE role = 'USER'`);

    // 5. 5 đơn gần nhất
    const recentBookings = await query(`
      SELECT 
        b.id,
        b.booking_code,
        b.guest_name,
        b.check_in,
        b.check_out,
        b.total_price,
        b.status,
        b.created_at,
        h.name as hotel_name,
        r.room_number
      FROM bookings b
      JOIN rooms r ON b.room_id = r.id
      JOIN hotels h ON r.hotel_id = h.id
      ORDER BY b.created_at DESC
      LIMIT 5
    `);

    return {
      revenue: parseFloat(revenueRow.total_revenue) || 0,
      bookings: {
        total: bookingStats.total_bookings || 0,
        confirmed: bookingStats.confirmed_bookings || 0,
        completed: bookingStats.completed_bookings || 0,
        cancelled: bookingStats.cancelled_bookings || 0,
      },
      hotels: {
        total: hotelCount.total_hotels || 0,
      },
      rooms: {
        total: roomCount.total_rooms || 0,
        available: roomCount.available_rooms || 0,
        maintenance: roomCount.maintenance_rooms || 0,
      },
      users: {
        total: userCount.total_users || 0,
      },
      recentBookings,
    };
  }
}

module.exports = BookingModel;
