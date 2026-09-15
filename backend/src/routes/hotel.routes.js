const express = require('express');
const router = express.Router();
const hotelController = require('../controllers/hotel.controller');
const { protect, restrictTo } = require('../middlewares/auth.middleware');
const { validateRequiredFields } = require('../middlewares/validate.middleware');

// Public routes
router.get('/', hotelController.getAllHotels);
router.get('/featured', hotelController.getFeaturedHotels);
router.get('/:id', hotelController.getHotelById);

const roomController = require('../controllers/room.controller');

// Reviews routes
router.get('/:hotelId/reviews', hotelController.getHotelReviews);
router.post(
  '/:hotelId/reviews',
  protect,
  validateRequiredFields(['rating', 'comment']),
  hotelController.createHotelReview
);

// Rooms & Room Types scoped to Hotel
router.get('/:hotelId/rooms', roomController.getRoomsByHotel);
router.get('/:hotelId/room-types', roomController.getRoomTypesByHotel);
router.get('/:hotelId/available-rooms', roomController.getAvailableRooms);
router.post(
  '/:hotelId/room-types',
  protect,
  restrictTo('ADMIN'),
  validateRequiredFields(['name', 'capacity', 'price']),
  roomController.createRoomType
);

// Admin-only routes
router.post(
  '/',
  protect,
  restrictTo('ADMIN'),
  validateRequiredFields(['name', 'address', 'city']),
  hotelController.createHotel
);

router.put('/:id', protect, restrictTo('ADMIN'), hotelController.updateHotel);
router.delete('/:id', protect, restrictTo('ADMIN'), hotelController.deleteHotel);

module.exports = router;
