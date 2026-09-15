const { query } = require('../config/db');

class ReviewModel {
  /**
   * Lấy danh sách đánh giá của 1 khách sạn
   */
  static async findByHotelId(hotelId) {
    const sql = `
      SELECT 
        r.id,
        r.hotel_id,
        r.rating,
        r.comment,
        r.created_at,
        u.id as user_id,
        u.name as user_name,
        u.avatar as user_avatar
      FROM reviews r
      JOIN users u ON r.user_id = u.id
      WHERE r.hotel_id = ?
      ORDER BY r.created_at DESC
    `;
    return query(sql, [hotelId]);
  }

  /**
   * Thêm đánh giá mới và tự động cập nhật rating trung bình của khách sạn
   */
  static async create({ userId, hotelId, rating, comment }) {
    const result = await query(
      `INSERT INTO reviews (user_id, hotel_id, rating, comment) VALUES (?, ?, ?, ?)`,
      [userId, hotelId, rating, comment]
    );

    // Cập nhật lại rating trung bình trong bảng hotels
    const [avgResult] = await query(
      `SELECT AVG(rating) as avg_rating FROM reviews WHERE hotel_id = ?`,
      [hotelId]
    );

    if (avgResult && avgResult.avg_rating) {
      const newRating = parseFloat(avgResult.avg_rating).toFixed(1);
      await query(`UPDATE hotels SET rating = ? WHERE id = ?`, [newRating, hotelId]);
    }

    return {
      id: result.insertId,
      userId,
      hotelId,
      rating,
      comment,
    };
  }
}

module.exports = ReviewModel;
