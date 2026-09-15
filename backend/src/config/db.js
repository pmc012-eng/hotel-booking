const mysql = require('mysql2/promise');
const config = require('./env');

// Tạo MySQL Connection Pool
const pool = mysql.createPool({
  host: config.db.host,
  port: config.db.port,
  user: config.db.user,
  password: config.db.password,
  database: config.db.database,
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0,
  enableKeepAlive: true,
  keepAliveInitialDelay: 0,
});

/**
 * Kiểm tra kết nối CSDL MySQL
 */
async function testConnection() {
  try {
    const connection = await pool.getConnection();
    console.log(`✅ Kết nối MySQL Database [${config.db.database}] thành công!`);
    connection.release();

    // Đảm bảo cột min_price tồn tại trong bảng hotels
    try {
      const cols = await query("SHOW COLUMNS FROM hotels LIKE 'min_price'");
      if (!cols || cols.length === 0) {
        await query("ALTER TABLE hotels ADD COLUMN min_price DECIMAL(12,2) NOT NULL DEFAULT 0");
        console.log("✅ Đã tự động thêm cột min_price vào bảng hotels!");
      }
    } catch (colErr) {
      console.warn("Lưu ý kiểm tra cột min_price:", colErr.message);
    }

    return true;
  } catch (error) {
    console.error('❌ Lỗi kết nối MySQL Database:', error.message);
    return false;
  }
}

/**
 * Helper thực thi truy vấn SQL với params
 */
async function query(sql, params = []) {
  try {
    const [rows, fields] = await pool.execute(sql, params);
    return rows;
  } catch (error) {
    console.error('❌ Lỗi SQL Query:', error.message, '\nQuery:', sql);
    throw error;
  }
}

module.exports = {
  pool,
  query,
  testConnection,
};
