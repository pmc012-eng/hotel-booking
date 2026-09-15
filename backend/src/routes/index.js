const express = require('express');
const router = express.Router();
const { sendSuccess } = require('../utils/response');
const { pool } = require('../config/db');

// Route kiểm tra sức khỏe và trạng thái CSDL
router.get('/health', async (req, res, next) => {
  try {
    const [result] = await pool.query('SELECT 1 as is_alive');
    return sendSuccess(
      res,
      {
        server: 'Online',
        database: result && result[0] && result[0].is_alive === 1 ? 'Connected' : 'Disconnected',
        timestamp: new Date().toISOString(),
      },
      'Hotel Booking API Base Architecture đang hoạt động chuẩn xác!'
    );
  } catch (err) {
    next(err);
  }
});

const authRoutes = require('./auth.routes');
const hotelRoutes = require('./hotel.routes');
const roomRoutes = require('./room.routes');
const bookingRoutes = require('./booking.routes');
const adminRoutes = require('./admin.routes');

// Mount routes
router.use('/auth', authRoutes);
router.use('/hotels', hotelRoutes);
router.use('/rooms', roomRoutes);
router.use('/bookings', bookingRoutes);
router.use('/admin', adminRoutes);

module.exports = router;
