const express = require('express');
const router = express.Router();
const authController = require('../controllers/auth.controller');
const { protect } = require('../middlewares/auth.middleware');
const {
  validateRequiredFields,
  validateEmail,
} = require('../middlewares/validate.middleware');

// Public routes
router.post(
  '/register',
  validateRequiredFields(['name', 'email', 'password']),
  validateEmail('email'),
  authController.register
);

router.post(
  '/login',
  validateRequiredFields(['email', 'password']),
  validateEmail('email'),
  authController.login
);

// Protected routes (Yêu cầu đăng nhập - JWT Token)
router.get('/me', protect, authController.getMe);
router.put('/profile', protect, authController.updateProfile);
router.put(
  '/change-password',
  protect,
  validateRequiredFields(['oldPassword', 'newPassword']),
  authController.changePassword
);

module.exports = router;
