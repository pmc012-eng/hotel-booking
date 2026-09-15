const { query } = require('../config/db');

class UserModel {
  /**
   * Tìm người dùng theo Email
   */
  static async findByEmail(email) {
    const rows = await query('SELECT * FROM users WHERE email = ? LIMIT 1', [email]);
    return rows[0] || null;
  }

  /**
   * Tìm người dùng theo ID (không trả về password)
   */
  static async findById(id) {
    const rows = await query(
      'SELECT id, name, email, phone, role, avatar, created_at, updated_at FROM users WHERE id = ? LIMIT 1',
      [id]
    );
    return rows[0] || null;
  }

  /**
   * Tìm người dùng theo ID kèm password (phục vụ đổi mật khẩu)
   */
  static async findByIdWithPassword(id) {
    const rows = await query('SELECT * FROM users WHERE id = ? LIMIT 1', [id]);
    return rows[0] || null;
  }

  /**
   * Tạo tài khoản người dùng mới
   */
  static async create({ name, email, password, phone = null, role = 'USER', avatar = null }) {
    const result = await query(
      `INSERT INTO users (name, email, password, phone, role, avatar) VALUES (?, ?, ?, ?, ?, ?)`,
      [name, email, password, phone, role, avatar]
    );
    return {
      id: result.insertId,
      name,
      email,
      phone,
      role,
      avatar,
    };
  }

  /**
   * Cập nhật thông tin hồ sơ cá nhân
   */
  static async updateProfile(id, { name, phone, avatar }) {
    await query(
      `UPDATE users SET name = COALESCE(?, name), phone = COALESCE(?, phone), avatar = COALESCE(?, avatar) WHERE id = ?`,
      [name ?? null, phone ?? null, avatar ?? null, id]
    );
    return this.findById(id);
  }

  /**
   * Cập nhật mật khẩu
   */
  static async updatePassword(id, hashedPassword) {
    await query(`UPDATE users SET password = ? WHERE id = ?`, [hashedPassword, id]);
    return true;
  }

  /**
   * Lấy danh sách tất cả người dùng (Admin)
   */
  static async findAll({ page = 1, limit = 20 } = {}) {
    const offset = (page - 1) * limit;
    const [countResult] = await query(`SELECT COUNT(*) as total FROM users`);
    const total = countResult ? countResult.total : 0;

    const rows = await query(
      `SELECT id, name, email, phone, role, avatar, created_at FROM users ORDER BY created_at DESC LIMIT ? OFFSET ?`,
      [limit, offset]
    );

    return {
      total,
      page,
      limit,
      totalPages: Math.ceil(total / limit),
      users: rows,
    };
  }
}

module.exports = UserModel;
