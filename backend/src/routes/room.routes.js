const express = require('express');
const router = express.Router();
const roomController = require('../controllers/room.controller');
const { protect, restrictTo } = require('../middlewares/auth.middleware');
const { validateRequiredFields } = require('../middlewares/validate.middleware');

// Public routes
router.get('/:id', roomController.getRoomById);

// Admin-only routes
router.post(
  '/',
  protect,
  restrictTo('ADMIN'),
  validateRequiredFields(['hotelId', 'roomNumber']),
  roomController.createRoom
);

router.put('/:id', protect, restrictTo('ADMIN'), roomController.updateRoom);
router.delete('/:id', protect, restrictTo('ADMIN'), roomController.deleteRoom);

module.exports = router;
