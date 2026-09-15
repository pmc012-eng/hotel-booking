const app = require('./src/app');
const config = require('./src/config/env');
const { testConnection } = require('./src/config/db');

const PORT = config.port;

async function startServer() {
  try {
    // 1. Kiểm tra kết nối CSDL trước khi khởi động HTTP server
    const isDbConnected = await testConnection();
    if (!isDbConnected) {
      console.error('❌ Không thể kết nối tới MySQL. Vui lòng bật XAMPP MySQL trước khi khởi động server!');
      process.exit(1);
    }

    // 2. Khởi động server
    const server = app.listen(PORT, () => {
      console.log(`\n======================================================`);
      console.log(`🏨 HOTEL BOOKING REST API SERVER`);
      console.log(`🚀 Trạng thái: Đang chạy trên cổng ${PORT}`);
      console.log(`🌐 Môi trường: ${config.nodeEnv}`);
      console.log(`🔗 API Health: http://localhost:${PORT}/api/health`);
      console.log(`📁 Static Assets: http://localhost:${PORT}/uploads/hotel_1.jpg`);
      console.log(`======================================================\n`);
    });

    // 3. Xử lý Unhandled Rejection
    process.on('unhandledRejection', (err) => {
      console.error('💥 UNHANDLED REJECTION! Đang tắt server an toàn...', err);
      server.close(() => {
        process.exit(1);
      });
    });

    // 4. Xử lý SIGTERM
    process.on('SIGTERM', () => {
      console.log('👋 Nhận tín hiệu SIGTERM. Đang dừng server nhẹ nhàng...');
      server.close(() => {
        console.log('💥 Tiến trình đã dừng.');
      });
    });
  } catch (err) {
    console.error('❌ Lỗi khởi động server:', err);
    process.exit(1);
  }
}

startServer();
