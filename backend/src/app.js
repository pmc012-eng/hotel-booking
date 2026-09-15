const express = require('express');
const cors = require('cors');
const morgan = require('morgan');
const path = require('path');
const routes = require('./routes');
const AppError = require('./utils/appError');
const globalErrorHandler = require('./middlewares/error.middleware');

const app = express();

// Middlewares xử lý request
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

if (process.env.NODE_ENV !== 'test') {
  app.use(morgan('dev'));
}

// Phục vụ tài nguyên ảnh tĩnh từ public/uploads
app.use('/uploads', express.static(path.join(__dirname, '../public/uploads')));

// Mount toàn bộ API Routes vào tiền tố /api
app.use('/api', routes);

// Xử lý các route không tồn tại (404 Not Found)
app.use((req, res, next) => {
  next(new AppError(`Không tìm thấy đường dẫn ${req.originalUrl} trên máy chủ!`, 404));
});

// Middleware xử lý lỗi toàn cục tập trung
app.use(globalErrorHandler);

module.exports = app;
