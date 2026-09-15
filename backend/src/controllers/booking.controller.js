const BookingModel = require('../models/booking.model');
const AppError = require('../utils/appError');
const catchAsync = require('../utils/catchAsync');
const { sendSuccess } = require('../utils/response');

/**
 * [POST] /api/bookings - Tạo đơn đặt phòng mới
 */
const createBooking = catchAsync(async (req, res, next) => {
  const { roomId, checkIn, checkOut, guestName, guestPhone, guestEmail, paymentMethod } = req.body;

  if (!roomId || !checkIn || !checkOut || !guestName || !guestPhone || !guestEmail) {
    return next(new AppError('Vui lòng cung cấp đầy đủ thông tin đặt phòng!', 400));
  }

  const checkInDate = new Date(checkIn);
  const checkOutDate = new Date(checkOut);

  if (isNaN(checkInDate.getTime()) || isNaN(checkOutDate.getTime())) {
    return next(new AppError('Định dạng ngày tháng không hợp lệ (chuẩn YYYY-MM-DD)!', 400));
  }

  const today = new Date();
  today.setHours(0, 0, 0, 0);
  const checkInZero = new Date(checkInDate);
  checkInZero.setHours(0, 0, 0, 0);

  if (checkInZero < today) {
    return next(new AppError('Ngày Check-in không thể ở trong quá khứ!', 400));
  }

  if (checkOutDate <= checkInDate) {
    return next(new AppError('Ngày Check-out phải sau ngày Check-in ít nhất 1 đêm!', 400));
  }

  try {
    const booking = await BookingModel.create({
      userId: req.user.id,
      roomId: parseInt(roomId, 10),
      checkIn,
      checkOut,
      guestName,
      guestPhone,
      guestEmail,
      paymentMethod: paymentMethod || 'PAY_AT_HOTEL',
    });

    return sendSuccess(res, booking, 'Đặt phòng khách sạn thành công!', 201);
  } catch (error) {
    return next(new AppError(error.message, 400));
  }
});

/**
 * [GET] /api/bookings/my-bookings - Lịch sử đặt phòng của người dùng hiện tại
 */
const getMyBookings = catchAsync(async (req, res, next) => {
  const { status } = req.query;
  const bookings = await BookingModel.findByUserId(req.user.id, status);
  return sendSuccess(res, bookings, 'Lấy danh sách đơn đặt phòng thành công!');
});

/**
 * [GET] /api/bookings/:id - Chi tiết 1 đơn đặt phòng
 */
const getBookingById = catchAsync(async (req, res, next) => {
  const booking = await BookingModel.findById(req.params.id);
  if (!booking) {
    return next(new AppError('Không tìm thấy đơn đặt phòng với ID này!', 404));
  }

  // Khách chỉ được xem đơn của mình, Admin được xem tất cả
  if (req.user.role !== 'ADMIN' && booking.user_id !== req.user.id) {
    return next(new AppError('Bạn không có quyền xem đơn đặt phòng này!', 403));
  }

  return sendSuccess(res, booking, 'Lấy chi tiết đơn đặt phòng thành công!');
});

/**
 * [PUT] /api/bookings/:id/cancel - Hủy đơn đặt phòng
 */
const cancelBooking = catchAsync(async (req, res, next) => {
  try {
    const cancelledBooking = await BookingModel.cancel(
      req.params.id,
      req.user.id,
      req.user.role
    );
    return sendSuccess(res, cancelledBooking, 'Hủy đơn đặt phòng thành công!');
  } catch (error) {
    return next(new AppError(error.message, 400));
  }
});

module.exports = {
  createBooking,
  getMyBookings,
  getBookingById,
  cancelBooking,
};
