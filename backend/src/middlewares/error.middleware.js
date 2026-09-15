const AppError = require('../utils/appError');

/**
 * Xử lý lỗi trùng lặp khóa duy nhất của MySQL (ví dụ: email trùng)
 */
function handleDuplicateFieldsDB(err) {
  let message = 'Dữ liệu đã tồn tại trong hệ thống!';
  if (err.sqlMessage && err.sqlMessage.includes('users.email')) {
    message = 'Email này đã được sử dụng. Vui lòng chọn email khác!';
  } else if (err.sqlMessage && err.sqlMessage.includes('bookings.booking_code')) {
    message = 'Mã đặt phòng đã tồn tại. Vui lòng thử lại!';
  } else if (err.sqlMessage && err.sqlMessage.includes('unique_hotel_room')) {
    message = 'Số phòng này đã tồn tại trong khách sạn!';
  }
  return new AppError(message, 400);
}

/**
 * Xử lý lỗi ràng buộc khóa ngoại MySQL
 */
function handleForeignKeyConstraintDB(err) {
  return new AppError('Dữ liệu liên kết không tồn tại hoặc đã bị ràng buộc!', 400);
}

/**
 * Xử lý lỗi JWT Token không hợp lệ
 */
function handleJWTError() {
  return new AppError('Token không hợp lệ hoặc đã bị thay đổi. Vui lòng đăng nhập lại!', 401);
}

/**
 * Xử lý lỗi JWT Token hết hạn
 */
function handleJWTExpiredError() {
  return new AppError('Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại!', 401);
}

/**
 * Middleware xử lý lỗi toàn cục (Global Error Handler)
 */
module.exports = (err, req, res, next) => {
  err.statusCode = err.statusCode || 500;
  err.status = err.status || 'error';

  let error = { ...err };
  error.message = err.message;
  error.name = err.name;
  error.code = err.code;
  error.sqlMessage = err.sqlMessage;

  // Nhận diện các lỗi phổ biến từ MySQL / JWT
  if (err.code === 'ER_DUP_ENTRY') error = handleDuplicateFieldsDB(err);
  if (err.code === 'ER_NO_REFERENCED_ROW_2') error = handleForeignKeyConstraintDB(err);
  if (err.name === 'JsonWebTokenError') error = handleJWTError();
  if (err.name === 'TokenExpiredError') error = handleJWTExpiredError();

  const isDevelopment = process.env.NODE_ENV === 'development';

  if (error.isOperational) {
    // Lỗi có thể lường trước (Operational, trusted error)
    return res.status(error.statusCode).json({
      status: error.status,
      message: error.message,
      ...(isDevelopment && { stack: err.stack }),
    });
  }

  // Lỗi lập trình hoặc lỗi không xác định khác (Programming or unknown error)
  console.error('💥 [UNHANDLED ERROR LOG]:', err);

  return res.status(500).json({
    status: 'error',
    message: isDevelopment ? err.message : 'Đã có lỗi xảy ra từ máy chủ, vui lòng thử lại sau!',
    ...(isDevelopment && { stack: err.stack, fullError: err }),
  });
};
