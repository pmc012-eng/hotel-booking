const jwt = require('jsonwebtoken');
const config = require('../config/env');
const AppError = require('../utils/appError');
const catchAsync = require('../utils/catchAsync');
const UserModel = require('../models/user.model');

/**
 * Middleware bảo vệ các route yêu cầu đăng nhập (JWT Authentication)
 */
const protect = catchAsync(async (req, res, next) => {
  let token;

  // 1. Lấy token từ Header Authorization (Bearer <token>)
  if (
    req.headers.authorization &&
    req.headers.authorization.startsWith('Bearer')
  ) {
    token = req.headers.authorization.split(' ')[1];
  }

  if (!token) {
    return next(
      new AppError('Vui lòng đăng nhập để truy cập tính năng này!', 401)
    );
  }

  // 2. Xác thực token
  const decoded = jwt.verify(token, config.jwt.secret);

  // 3. Kiểm tra xem người dùng còn tồn tại trong CSDL không
  const currentUser = await UserModel.findById(decoded.id);
  if (!currentUser) {
    return next(
      new AppError('Tài khoản thuộc token này không còn tồn tại trên hệ thống!', 401)
    );
  }

  // 4. Lưu thông tin user vào request để các middleware/controller tiếp theo sử dụng
  req.user = currentUser;
  next();
});

/**
 * Middleware phân quyền (Role-based Access Control)
 * @param  {...string} roles - Danh sách vai trò được phép (ví dụ: 'ADMIN', 'USER')
 */
const restrictTo = (...roles) => {
  return (req, res, next) => {
    if (!req.user || !roles.includes(req.user.role)) {
      return next(
        new AppError('Bạn không có quyền thực hiện hành động này!', 403)
      );
    }
    next();
  };
};

module.exports = {
  protect,
  restrictTo,
};
