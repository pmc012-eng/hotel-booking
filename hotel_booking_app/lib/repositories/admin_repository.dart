import '../core/constants/api_endpoints.dart';
import '../core/network/api_client.dart';
import '../models/admin_stats_model.dart';
import '../models/booking_model.dart';
import '../models/hotel_model.dart';
import '../models/room_model.dart';
import '../models/user_model.dart';

class AdminRepository {
  final ApiClient _client;

  AdminRepository({ApiClient? client}) : _client = client ?? apiClient;

  /// Lấy thống kê tổng quan
  Future<AdminStatsModel> getStatistics() async {
    final response = await _client.get(ApiEndpoints.adminStats);
    final data = response.data['data'] as Map<String, dynamic>;
    return AdminStatsModel.fromJson(data);
  }

  /// Lấy toàn bộ đơn đặt phòng (Admin)
  Future<List<BookingModel>> getAllBookings({String? status, int page = 1, int limit = 50}) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'limit': limit,
    };
    if (status != null && status.isNotEmpty && status != 'ALL') {
      queryParams['status'] = status;
    }

    final response = await _client.get(
      ApiEndpoints.adminBookings,
      queryParameters: queryParams,
    );
    final data = response.data['data'] as Map<String, dynamic>;
    final list = data['bookings'] as List;
    return list.map((item) => BookingModel.fromJson(item as Map<String, dynamic>)).toList();
  }

  /// Cập nhật trạng thái đơn đặt phòng (CONFIRMED, COMPLETED, CANCELLED)
  Future<BookingModel> updateBookingStatus(int id, String status) async {
    final response = await _client.put(
      ApiEndpoints.updateBookingStatus(id),
      data: {'status': status},
    );
    final data = response.data['data'] as Map<String, dynamic>;
    return BookingModel.fromJson(data);
  }

  /// Lấy danh sách tất cả người dùng
  Future<List<UserModel>> getAllUsers({int page = 1, int limit = 50}) async {
    final response = await _client.get(
      ApiEndpoints.adminUsers,
      queryParameters: {'page': page, 'limit': limit},
    );
    final data = response.data['data'] as Map<String, dynamic>;
    final list = data['users'] as List;
    return list.map((item) => UserModel.fromJson(item as Map<String, dynamic>)).toList();
  }

  /// Thêm khách sạn mới
  Future<HotelModel> createHotel(Map<String, dynamic> hotelData) async {
    final response = await _client.post(ApiEndpoints.hotels, data: hotelData);
    final data = response.data['data'] as Map<String, dynamic>;
    return HotelModel.fromJson(data);
  }

  /// Cập nhật thông tin khách sạn
  Future<HotelModel> updateHotel(int id, Map<String, dynamic> hotelData) async {
    final response = await _client.put(ApiEndpoints.hotelDetail(id), data: hotelData);
    final data = response.data['data'] as Map<String, dynamic>;
    return HotelModel.fromJson(data);
  }

  /// Xóa khách sạn
  Future<bool> deleteHotel(int id) async {
    await _client.delete(ApiEndpoints.hotelDetail(id));
    return true;
  }

  /// Thêm phòng mới
  Future<RoomModel> createRoom(Map<String, dynamic> roomData) async {
    final response = await _client.post('/rooms', data: roomData);
    final data = response.data['data'] as Map<String, dynamic>;
    return RoomModel.fromJson(data);
  }

  /// Cập nhật thông tin / trạng thái phòng
  Future<RoomModel> updateRoom(int id, Map<String, dynamic> roomData) async {
    final response = await _client.put(ApiEndpoints.roomDetail(id), data: roomData);
    final data = response.data['data'] as Map<String, dynamic>;
    return RoomModel.fromJson(data);
  }

  /// Xóa phòng
  Future<bool> deleteRoom(int id) async {
    await _client.delete(ApiEndpoints.roomDetail(id));
    return true;
  }
}

final adminRepository = AdminRepository();
