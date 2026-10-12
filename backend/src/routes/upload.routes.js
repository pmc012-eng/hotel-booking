const express = require('express');
const router = express.Router();
const { protect } = require('../middlewares/auth.middleware');
const { createUploader } = require('../middlewares/upload.middleware');
const AppError = require('../utils/appError');
const { sendSuccess } = require('../utils/response');

const uploader = createUploader();

/**
 * [POST] /api/upload - Tải lên 1 ảnh đơn (hỗ trợ type=hotel, type=room, type=avatar)
 */
router.post('/', protect, uploader.single('image'), (req, res, next) => {
  if (!req.file) {
    return next(new AppError('Vui lòng chọn tệp ảnh để tải lên!', 400));
  }

  const type = (req.query.type || req.body.type || 'general').toLowerCase();
  let subfolder = 'general';
  if (type.includes('avatar') || type.includes('user')) subfolder = 'avatars';
  else if (type.includes('hotel')) subfolder = 'hotels';
  else if (type.includes('room')) subfolder = 'rooms';

  const relativeUrl = `/uploads/${subfolder}/${req.file.filename}`;

  return sendSuccess(
    res,
    {
      url: relativeUrl,
      filename: req.file.filename,
      size: req.file.size,
      mimetype: req.file.mimetype,
    },
    'Tải ảnh lên thành công!',
    201
  );
});

/**
 * [POST] /api/upload/multiple - Tải lên nhiều ảnh cùng lúc (tối đa 10 ảnh)
 */
router.post('/multiple', protect, uploader.array('images', 10), (req, res, next) => {
  if (!req.files || req.files.length === 0) {
    return next(new AppError('Vui lòng chọn ít nhất một ảnh để tải lên!', 400));
  }

  const type = (req.query.type || req.body.type || 'general').toLowerCase();
  let subfolder = 'general';
  if (type.includes('avatar') || type.includes('user')) subfolder = 'avatars';
  else if (type.includes('hotel')) subfolder = 'hotels';
  else if (type.includes('room')) subfolder = 'rooms';

  const results = req.files.map((file) => ({
    url: `/uploads/${subfolder}/${file.filename}`,
    filename: file.filename,
    size: file.size,
  }));

  return sendSuccess(
    res,
    {
      urls: results.map((r) => r.url),
      files: results,
    },
    'Tải danh sách ảnh thành công!',
    201
  );
});

module.exports = router;
