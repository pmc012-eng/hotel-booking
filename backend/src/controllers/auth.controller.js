const jwt = require('jsonwebtoken');
const bcrypt = require('bcryptjs');
const config = require('../config/env');
const AppError = require('../utils/appError');
const catchAsync = require('../utils/catchAsync');
const { sendSuccess } = require('../utils/response');
const UserModel = require('../models/user.model');

/**
 * Cấp phát JSON Web Token
 */
function signToken(id) {
  return jwt.sign({ id }, config.jwt.secret, {
    expiresIn: config.jwt.expiresIn,
  });
}

/**
 * [POST] /api/auth/register - Đăng ký tài khoản mới
 */
const register = catchAsync(async (req, res, next) => {
  const { name, email, password, phone } = req.body;

  // 1. Kiểm tra email đã tồn tại chưa
  const existingUser = await UserModel.findByEmail(email);
  if (existingUser) {
    return next(new AppError('Email này đã được đăng ký trong hệ thống!', 400));
  }

  // 2. Mã hóa mật khẩu
  const hashedPassword = await bcrypt.hash(password, 10);

  // 3. Tạo tài khoản người dùng mới (mặc định role USER)
  const newUser = await UserModel.create({
    name: name.trim(),
    email: email.trim().toLowerCase(),
    password: hashedPassword,
    phone: phone ? phone.trim() : null,
    role: 'USER',
    avatar: `https://ui-avatars.com/api/?name=${encodeURIComponent(name)}&background=2563EB&color=fff&size=200`,
  });

  // 4. Tạo token và gửi phản hồi
  const token = signToken(newUser.id);

  return sendSuccess(
    res,
    {
      token,
      user: newUser,
    },
    'Đăng ký tài khoản thành công!',
    201
  );
});

/**
 * [POST] /api/auth/login - Đăng nhập tài khoản
 */
const login = catchAsync(async (req, res, next) => {
  const { email, password } = req.body;

  // 1. Tìm người dùng theo email
  const user = await UserModel.findByEmail(email.trim().toLowerCase());
  if (!user) {
    return next(new AppError('Email hoặc mật khẩu không chính xác!', 401));
  }

  // 2. Kiểm tra mật khẩu với bcrypt
  const isMatch = await bcrypt.compare(password, user.password);
  if (!isMatch) {
    return next(new AppError('Email hoặc mật khẩu không chính xác!', 401));
  }

  // 3. Tạo JWT Token
  const token = signToken(user.id);

  // 4. Loại bỏ mật khẩu trước khi trả về client
  delete user.password;

  return sendSuccess(
    res,
    {
      token,
      user,
    },
    'Đăng nhập thành công!'
  );
});

/**
 * [GET] /api/auth/me - Lấy thông tin tài khoản hiện tại
 */
const getMe = catchAsync(async (req, res, next) => {
  return sendSuccess(
    res,
    {
      user: req.user,
    },
    'Lấy thông tin tài khoản thành công!'
  );
});

/**
 * [PUT] /api/auth/profile - Cập nhật thông tin hồ sơ
 */
const updateProfile = catchAsync(async (req, res, next) => {
  const { name, phone, avatar } = req.body;

  const updatedUser = await UserModel.updateProfile(req.user.id, {
    name,
    phone,
    avatar,
  });

  return sendSuccess(
    res,
    {
      user: updatedUser,
    },
    'Cập nhật thông tin hồ sơ thành công!'
  );
});

/**
 * [PUT] /api/auth/change-password - Đổi mật khẩu
 */
const changePassword = catchAsync(async (req, res, next) => {
  const { oldPassword, newPassword } = req.body;

  if (newPassword.length < 6) {
    return next(new AppError('Mật khẩu mới phải chứa ít nhất 6 ký tự!', 400));
  }

  // 1. Lấy thông tin user kèm password hiện tại
  const user = await UserModel.findByIdWithPassword(req.user.id);

  // 2. Kiểm tra mật khẩu cũ
  const isMatch = await bcrypt.compare(oldPassword, user.password);
  if (!isMatch) {
    return next(new AppError('Mật khẩu hiện tại không chính xác!', 400));
  }

  // 3. Hash mật khẩu mới và lưu vào CSDL
  const hashedNewPassword = await bcrypt.hash(newPassword, 10);
  await UserModel.updatePassword(req.user.id, hashedNewPassword);

  return sendSuccess(res, null, 'Đổi mật khẩu thành công!');
});

/**
 * [PUT/POST] /api/auth/avatar - Cập nhật ảnh đại diện người dùng
 */
const uploadAvatar = catchAsync(async (req, res, next) => {
  if (!req.file) {
    return next(new AppError('Vui lòng chọn tệp ảnh để tải lên làm ảnh đại diện!', 400));
  }

  // Đường dẫn tương đối phục vụ từ static express
  const avatarPath = `/uploads/avatars/${req.file.filename}`;

  const updatedUser = await UserModel.updateProfile(req.user.id, {
    avatar: avatarPath,
  });

  return sendSuccess(
    res,
    {
      user: updatedUser,
      avatar: avatarPath,
    },
    'Cập nhật ảnh đại diện thành công!'
  );
});

module.exports = {
  register,
  login,
  getMe,
  updateProfile,
  changePassword,
  uploadAvatar,
};
