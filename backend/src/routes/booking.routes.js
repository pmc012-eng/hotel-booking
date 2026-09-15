const express = require('express');
const router = express.Router();
const bookingController = require('../controllers/booking.controller');
const { protect } = require('../middlewares/auth.middleware');

// Toàn bộ route booking đều yêu cầu xác thực JWT (protect)
router.use(protect);

router.post('/', bookingController.createBooking);
router.get('/my-bookings', bookingController.getMyBookings);
router.get('/:id', bookingController.getBookingById);
router.put('/:id/cancel', bookingController.cancelBooking);

module.exports = router;
