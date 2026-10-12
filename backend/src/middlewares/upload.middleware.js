const multer = require('multer');
const path = require('path');
const fs = require('fs');
const AppError = require('../utils/appError');

// Bộ lọc định dạng file: chỉ cho phép ảnh
const imageFileFilter = (req, file, cb) => {
  const allowedMimeTypes = [
    'image/jpeg',
    'image/png',
    'image/webp',
    'image/jpg',
    'image/heic',
    'image/heif',
    'image/gif',
  ];

  if (allowedMimeTypes.includes(file.mimetype.toLowerCase())) {
    cb(null, true);
  } else {
    cb(new AppError('Chỉ chấp nhận các tệp định dạng ảnh (JPEG, PNG, WEBP, GIF, HEIC)!', 400), false);
  }
};

function createUploader(defaultSubdir = 'general') {
  const storage = multer.diskStorage({
    destination: (req, file, cb) => {
      const type = (req.query.type || req.body.type || defaultSubdir).toLowerCase();
      let subfolder = 'general';
      if (type.includes('avatar') || type.includes('user')) subfolder = 'avatars';
      else if (type.includes('hotel')) subfolder = 'hotels';
      else if (type.includes('room')) subfolder = 'rooms';

      const dir = path.join(__dirname, `../../public/uploads/${subfolder}`);
      if (!fs.existsSync(dir)) {
        fs.mkdirSync(dir, { recursive: true });
      }
      cb(null, dir);
    },
    filename: (req, file, cb) => {
      const type = (req.query.type || req.body.type || defaultSubdir).toLowerCase();
      let prefix = 'upload';
      if (type.includes('avatar')) {
        const userId = req.user ? req.user.id : 'unknown';
        prefix = `avatar-${userId}`;
      } else if (type.includes('hotel')) {
        prefix = 'hotel';
      } else if (type.includes('room')) {
        prefix = 'room';
      }

      const ext = path.extname(file.originalname).toLowerCase() || '.jpg';
      const uniqueSuffix = `${Date.now()}-${Math.round(Math.random() * 1e9)}`;
      cb(null, `${prefix}-${uniqueSuffix}${ext}`);
    },
  });

  return multer({
    storage,
    fileFilter: imageFileFilter,
    limits: {
      fileSize: 10 * 1024 * 1024, // Giới hạn 10MB
    },
  });
}

// Giữ tương thích ngược với avatar middleware cũ
const uploadAvatar = createUploader('avatars');
const uploadGeneral = createUploader('general');

module.exports = {
  createUploader,
  uploadAvatar,
  uploadGeneral,
};
