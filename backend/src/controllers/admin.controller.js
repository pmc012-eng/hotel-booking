const BookingModel = require('../models/booking.model');
const UserModel = require('../models/user.model');
const catchAsync = require('../utils/catchAsync');
const AppError = require('../utils/appError');
const { sendSuccess } = require('../utils/response');

/**
 * [GET] /api/admin/statistics - Thống kê tổng quan cho Dashboard
 */
const getStatistics = catchAsync(async (req, res, next) => {
  const stats = await BookingModel.getStatistics();
  return sendSuccess(res, stats, 'Lấy thống kê hệ thống thành công!');
});

/**
 * [GET] /api/admin/bookings - Danh sách tất cả đơn đặt phòng
 */
const getAllBookings = catchAsync(async (req, res, next) => {
  const { status, page = 1, limit = 20 } = req.query;

  const result = await BookingModel.findAll({
    status: status || null,
    page: parseInt(page, 10),
    limit: parseInt(limit, 10),
  });

  return sendSuccess(res, result, 'Lấy danh sách tất cả đơn đặt phòng thành công!');
});

/**
 * [PUT] /api/admin/bookings/:id/status - Cập nhật trạng thái đơn đặt phòng
 */
const updateBookingStatus = catchAsync(async (req, res, next) => {
  const { status } = req.body;
  const { id } = req.params;

  if (!status) {
    return next(new AppError('Vui lòng cung cấp trạng thái mới cho đơn đặt phòng!', 400));
  }

  try {
    const updatedBooking = await BookingModel.updateStatus(id, status);
    return sendSuccess(res, updatedBooking, 'Cập nhật trạng thái đơn đặt phòng thành công!');
  } catch (error) {
    return next(new AppError(error.message, 400));
  }
});

/**
 * [GET] /api/admin/users - Danh sách người dùng
 */
const getAllUsers = catchAsync(async (req, res, next) => {
  const { page = 1, limit = 20 } = req.query;

  const result = await UserModel.findAll({
    page: parseInt(page, 10),
    limit: parseInt(limit, 10),
  });

  return sendSuccess(res, result, 'Lấy danh sách người dùng thành công!');
});

module.exports = {
  getStatistics,
  getAllBookings,
  updateBookingStatus,
  getAllUsers,
};
