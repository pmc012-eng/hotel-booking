const AppError = require('../utils/appError');

/**
 * Middleware kiểm tra các trường bắt buộc trong req.body
 */
function validateRequiredFields(fields = []) {
  return (req, res, next) => {
    const missing = [];
    for (const field of fields) {
      if (
        req.body[field] === undefined ||
        req.body[field] === null ||
        (typeof req.body[field] === 'string' && req.body[field].trim() === '')
      ) {
        missing.push(field);
      }
    }

    if (missing.length > 0) {
      return next(
        new AppError(
          `Vui lòng cung cấp đầy đủ thông tin: ${missing.join(', ')}`,
          400
        )
      );
    }

    next();
  };
}

/**
 * Middleware kiểm tra email hợp lệ
 */
function validateEmail(field = 'email') {
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  return (req, res, next) => {
    const email = req.body[field];
    if (email && !emailRegex.test(email)) {
      return next(new AppError('Địa chỉ email không đúng định dạng!', 400));
    }
    next();
  };
}

module.exports = {
  validateRequiredFields,
  validateEmail,
};
