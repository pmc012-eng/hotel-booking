const HotelModel = require('../models/hotel.model');
const ReviewModel = require('../models/review.model');
const AppError = require('../utils/appError');
const catchAsync = require('../utils/catchAsync');
const { sendSuccess, sendPaginated } = require('../utils/response');

/**
 * [GET] /api/hotels - Lấy danh sách khách sạn có tìm kiếm, lọc & phân trang
 */
const getAllHotels = catchAsync(async (req, res, next) => {
  const { search, city, star, minPrice, maxPrice, sortBy, page = 1, limit = 10 } = req.query;

  const { items, total } = await HotelModel.findAll({
    search,
    city,
    star,
    minPrice,
    maxPrice,
    sortBy,
    page: parseInt(page, 10),
    limit: parseInt(limit, 10),
  });

  return sendPaginated(res, items, total, page, limit, 'Lấy danh sách khách sạn thành công!');
});

/**
 * [GET] /api/hotels/featured - Lấy danh sách khách sạn nổi bật
 */
const getFeaturedHotels = catchAsync(async (req, res, next) => {
  const limit = parseInt(req.query.limit, 10) || 6;
  const hotels = await HotelModel.findFeatured(limit);
  return sendSuccess(res, hotels, 'Lấy danh sách khách sạn nổi bật thành công!');
});

/**
 * [GET] /api/hotels/:id - Lấy chi tiết khách sạn
 */
const getHotelById = catchAsync(async (req, res, next) => {
  const hotel = await HotelModel.findById(req.params.id);
  if (!hotel) {
    return next(new AppError('Không tìm thấy khách sạn với ID đã cung cấp!', 404));
  }
  return sendSuccess(res, hotel, 'Lấy chi tiết khách sạn thành công!');
});

/**
 * [POST] /api/hotels - Tạo khách sạn mới (ADMIN)
 */
const createHotel = catchAsync(async (req, res, next) => {
  const { name, description, address, city, star, rating, images, minPrice, min_price, image, primaryImage } = req.body;
  
  let finalImages = images;
  if (!finalImages || !Array.isArray(finalImages) || finalImages.length === 0) {
    if (primaryImage) finalImages = [primaryImage];
    else if (image) finalImages = [image];
  }

  const newHotel = await HotelModel.create({
    name,
    description,
    address,
    city,
    star,
    rating,
    images: finalImages,
    minPrice: minPrice ?? min_price ?? 0,
  });
  return sendSuccess(res, newHotel, 'Thêm mới khách sạn thành công!', 201);
});

/**
 * [PUT] /api/hotels/:id - Cập nhật thông tin khách sạn (ADMIN)
 */
const updateHotel = catchAsync(async (req, res, next) => {
  let images = req.body.images;
  if (!images && (req.body.primaryImage || req.body.image)) {
    images = [req.body.primaryImage || req.body.image];
  }

  const updatedHotel = await HotelModel.update(req.params.id, {
    ...req.body,
    images,
    minPrice: req.body.minPrice ?? req.body.min_price,
  });
  if (!updatedHotel) {
    return next(new AppError('Không tìm thấy khách sạn để cập nhật!', 404));
  }
  return sendSuccess(res, updatedHotel, 'Cập nhật thông tin khách sạn thành công!');
});

/**
 * [DELETE] /api/hotels/:id - Xóa khách sạn (ADMIN)
 */
const deleteHotel = catchAsync(async (req, res, next) => {
  const isDeleted = await HotelModel.delete(req.params.id);
  if (!isDeleted) {
    return next(new AppError('Không tìm thấy khách sạn để xóa!', 404));
  }
  return sendSuccess(res, null, 'Xóa khách sạn thành công!');
});

/**
 * [GET] /api/hotels/:hotelId/reviews - Lấy danh sách đánh giá của khách sạn
 */
const getHotelReviews = catchAsync(async (req, res, next) => {
  const reviews = await ReviewModel.findByHotelId(req.params.hotelId);
  return sendSuccess(res, reviews, 'Lấy danh sách đánh giá khách sạn thành công!');
});

/**
 * [POST] /api/hotels/:hotelId/reviews - Thêm đánh giá mới (Yêu cầu đăng nhập)
 */
const createHotelReview = catchAsync(async (req, res, next) => {
  const { rating, comment } = req.body;
  const hotelId = req.params.hotelId;

  if (!rating || rating < 1 || rating > 5) {
    return next(new AppError('Điểm đánh giá phải từ 1 đến 5 sao!', 400));
  }
  if (!comment || comment.trim() === '') {
    return next(new AppError('Vui lòng nhập nội dung đánh giá!', 400));
  }

  const newReview = await ReviewModel.create({
    userId: req.user.id,
    hotelId,
    rating: parseInt(rating, 10),
    comment: comment.trim(),
  });

  return sendSuccess(res, newReview, 'Đánh giá khách sạn thành công!', 201);
});

module.exports = {
  getAllHotels,
  getFeaturedHotels,
  getHotelById,
  createHotel,
  updateHotel,
  deleteHotel,
  getHotelReviews,
  createHotelReview,
};
