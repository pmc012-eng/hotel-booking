const express = require('express');
const router = express.Router();
const adminController = require('../controllers/admin.controller');
const { protect, restrictTo } = require('../middlewares/auth.middleware');

// Tất cả các routes trong phân hệ Admin đều yêu cầu đăng nhập và có Role là ADMIN
router.use(protect, restrictTo('ADMIN'));

// Thống kê Dashboard
router.get('/statistics', adminController.getStatistics);

// Quản lý Booking
router.get('/bookings', adminController.getAllBookings);
router.put('/bookings/:id/status', adminController.updateBookingStatus);

// Quản lý Người dùng
router.get('/users', adminController.getAllUsers);

module.exports = router;
