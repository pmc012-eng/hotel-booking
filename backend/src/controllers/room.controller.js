const RoomModel = require('../models/room.model');
const AppError = require('../utils/appError');
const catchAsync = require('../utils/catchAsync');
const { sendSuccess } = require('../utils/response');
const { query } = require('../config/db');

/**
 * [GET] /api/hotels/:hotelId/rooms - Lấy danh sách tất cả phòng của khách sạn
 */
const getRoomsByHotel = catchAsync(async (req, res, next) => {
  const rooms = await RoomModel.findByHotelId(req.params.hotelId);
  return sendSuccess(res, rooms, 'Lấy danh sách phòng của khách sạn thành công!');
});

/**
 * [GET] /api/hotels/:hotelId/room-types - Lấy danh sách loại phòng của khách sạn
 */
const getRoomTypesByHotel = catchAsync(async (req, res, next) => {
  const roomTypes = await RoomModel.findRoomTypesByHotelId(req.params.hotelId);
  return sendSuccess(res, roomTypes, 'Lấy danh sách loại phòng thành công!');
});

/**
 * [GET] /api/hotels/:hotelId/available-rooms - Tìm phòng còn trống theo khoảng ngày
 */
const getAvailableRooms = catchAsync(async (req, res, next) => {
  const { checkIn, checkOut, roomTypeId } = req.query;
  const hotelId = req.params.hotelId;

  if (!checkIn || !checkOut) {
    return next(new AppError('Vui lòng chọn đầy đủ ngày Check-in và Check-out!', 400));
  }

  const checkInDate = new Date(checkIn);
  const checkOutDate = new Date(checkOut);

  if (isNaN(checkInDate.getTime()) || isNaN(checkOutDate.getTime())) {
    return next(new AppError('Định dạng ngày tháng không hợp lệ (chuẩn YYYY-MM-DD)!', 400));
  }

  // Kiểm tra ngày không được ở quá khứ
  const today = new Date();
  today.setHours(0, 0, 0, 0);

  const checkInZero = new Date(checkInDate);
  checkInZero.setHours(0, 0, 0, 0);

  if (checkInZero < today) {
    return next(new AppError('Ngày Check-in không thể ở trong quá khứ!', 400));
  }

  if (checkOutDate <= checkInDate) {
    return next(new AppError('Ngày Check-out phải sau ngày Check-in ít nhất 1 đêm!', 400));
  }

  const availableRooms = await RoomModel.findAvailableRooms(hotelId, {
    checkIn,
    checkOut,
    roomTypeId: roomTypeId ? parseInt(roomTypeId, 10) : null,
  });

  return sendSuccess(
    res,
    {
      hotelId: parseInt(hotelId, 10),
      checkIn,
      checkOut,
      totalAvailable: availableRooms.length,
      rooms: availableRooms,
    },
    'Lấy danh sách phòng trống thành công!'
  );
});

/**
 * [GET] /api/rooms/:id - Chi tiết 1 phòng
 */
const getRoomById = catchAsync(async (req, res, next) => {
  const room = await RoomModel.findById(req.params.id);
  if (!room) {
    return next(new AppError('Không tìm thấy phòng với ID đã cung cấp!', 404));
  }
  return sendSuccess(res, room, 'Lấy chi tiết phòng thành công!');
});

/**
 * [POST] /api/rooms - Thêm phòng mới (ADMIN)
 */
const createRoom = catchAsync(async (req, res, next) => {
  let { hotelId, roomTypeId, roomNumber, roomTypeName, price, capacity, status, amenities, imageUrl } = req.body;
  
  if (!hotelId || !roomNumber) {
    return next(new AppError('Vui lòng cung cấp hotelId và số phòng (roomNumber)!', 400));
  }

  // Nếu không truyền roomTypeId, tìm xem khách sạn đã có loại phòng trùng tên chưa hoặc tạo loại phòng mới
  if (!roomTypeId || roomTypeId === 0) {
    const rtName = (roomTypeName && roomTypeName.trim()) ? roomTypeName.trim() : 'Phòng Tiêu Chuẩn';
    const rtPrice = price ? parseFloat(price) : 1000000;
    const rtCapacity = capacity ? parseInt(capacity, 10) : 2;
    const rtAmenities = Array.isArray(amenities)
      ? amenities
      : (typeof amenities === 'string' && amenities.trim()
          ? amenities.split(',').map((s) => s.trim())
          : ['Wifi', 'Điều hòa', 'TV']);

    // Kiểm tra xem đã có room_type trùng tên trong hotel chưa
    const existingRoomTypes = await RoomModel.findRoomTypesByHotelId(hotelId);
    const matched = existingRoomTypes.find(
      (rt) => rt.name.toLowerCase() === rtName.toLowerCase()
    );

    if (matched) {
      roomTypeId = matched.id;
    } else {
      const newRt = await RoomModel.createRoomType({
        hotelId,
        name: rtName,
        description: `Loại phòng ${rtName} tiện nghi đầy đủ`,
        capacity: rtCapacity,
        price: rtPrice,
        imageUrl: imageUrl || '/uploads/room_1.jpg',
        amenities: rtAmenities,
      });
      roomTypeId = newRt.id;
    }
  }

  const newRoom = await RoomModel.create({
    hotelId,
    roomTypeId,
    roomNumber,
    status: status || 'AVAILABLE',
  });

  // Đồng thời cập nhật min_price của khách sạn nếu cần
  try {
    const [priceRow] = await query(
      `SELECT MIN(price) as min_p FROM room_types WHERE hotel_id = ?`,
      [hotelId]
    );
    if (priceRow && priceRow.min_p) {
      await query(
        `UPDATE hotels SET min_price = ? WHERE id = ?`,
        [priceRow.min_p, hotelId]
      );
    }
  } catch (e) {
    console.warn('Cập nhật min_price sau khi tạo phòng:', e.message);
  }

  return sendSuccess(res, newRoom, 'Thêm phòng mới thành công!', 201);
});

/**
 * [PUT] /api/rooms/:id - Cập nhật phòng (ADMIN)
 */
const updateRoom = catchAsync(async (req, res, next) => {
  const updatedRoom = await RoomModel.update(req.params.id, req.body);
  if (!updatedRoom) {
    return next(new AppError('Không tìm thấy phòng để cập nhật!', 404));
  }
  return sendSuccess(res, updatedRoom, 'Cập nhật thông tin phòng thành công!');
});

/**
 * [DELETE] /api/rooms/:id - Xóa phòng (ADMIN)
 */
const deleteRoom = catchAsync(async (req, res, next) => {
  const room = await RoomModel.findById(req.params.id);
  const isDeleted = await RoomModel.delete(req.params.id);
  if (!isDeleted) {
    return next(new AppError('Không tìm thấy phòng để xóa!', 404));
  }

  if (room && room.hotel_id) {
    try {
      const [priceRow] = await query(
        `SELECT MIN(rt.price) as min_p 
         FROM rooms r 
         JOIN room_types rt ON r.room_type_id = rt.id 
         WHERE r.hotel_id = ?`,
        [room.hotel_id]
      );
      const newMin = priceRow && priceRow.min_p ? priceRow.min_p : 0;
      await query(`UPDATE hotels SET min_price = ? WHERE id = ?`, [newMin, room.hotel_id]);
    } catch (_) {}
  }

  return sendSuccess(res, null, 'Xóa phòng thành công!');
});

/**
 * [POST] /api/hotels/:hotelId/room-types - Thêm loại phòng mới (ADMIN)
 */
const createRoomType = catchAsync(async (req, res, next) => {
  const { name, description, capacity, price, imageUrl, amenities } = req.body;
  const hotelId = req.params.hotelId;

  const newRoomType = await RoomModel.createRoomType({
    hotelId,
    name,
    description,
    capacity,
    price,
    imageUrl,
    amenities,
  });

  return sendSuccess(res, newRoomType, 'Tạo loại phòng mới thành công!', 201);
});

module.exports = {
  getRoomsByHotel,
  getRoomTypesByHotel,
  getAvailableRooms,
  getRoomById,
  createRoom,
  updateRoom,
  deleteRoom,
  createRoomType,
};
