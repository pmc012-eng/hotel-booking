import '../core/constants/api_endpoints.dart';
import '../core/network/api_client.dart';
import '../models/room_model.dart';

class RoomRepository {
  final ApiClient _client;

  RoomRepository({ApiClient? client}) : _client = client ?? apiClient;

  /// Lấy danh sách tất cả phòng của khách sạn
  Future<List<RoomModel>> getRoomsByHotel(int hotelId) async {
    final response = await _client.get(ApiEndpoints.hotelRooms(hotelId));
    final list = response.data['data'] as List;
    return list.map((item) => RoomModel.fromJson(item as Map<String, dynamic>)).toList();
  }

  /// Lấy danh sách loại phòng của khách sạn
  Future<List<RoomTypeModel>> getRoomTypesByHotel(int hotelId) async {
    final response = await _client.get('/hotels/$hotelId/room-types');
    final list = response.data['data'] as List;
    return list.map((item) => RoomTypeModel.fromJson(item as Map<String, dynamic>)).toList();
  }

  /// Tìm phòng còn trống theo khoảng ngày
  Future<List<RoomModel>> getAvailableRooms(
    int hotelId, {
    required String checkIn,
    required String checkOut,
    int? roomTypeId,
  }) async {
    final queryParams = <String, dynamic>{
      'checkIn': checkIn,
      'checkOut': checkOut,
    };
    if (roomTypeId != null) {
      queryParams['roomTypeId'] = roomTypeId;
    }

    final response = await _client.get(
      ApiEndpoints.availableRooms(hotelId),
      queryParameters: queryParams,
    );
    final data = response.data['data'] as Map<String, dynamic>;
    final list = data['rooms'] as List;
    return list.map((item) => RoomModel.fromJson(item as Map<String, dynamic>)).toList();
  }

  /// Chi tiết một phòng cụ thể
  Future<RoomModel> getRoomById(int id) async {
    final response = await _client.get(ApiEndpoints.roomDetail(id));
    final data = response.data['data'] as Map<String, dynamic>;
    return RoomModel.fromJson(data);
  }
}

final roomRepository = RoomRepository();
