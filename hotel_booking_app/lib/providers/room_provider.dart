import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/room_model.dart';
import '../repositories/room_repository.dart';

final roomRepositoryProvider = Provider<RoomRepository>((ref) {
  return roomRepository;
});

/// Danh sách tất cả phòng của khách sạn
final hotelRoomsProvider = FutureProvider.family<List<RoomModel>, int>((ref, hotelId) async {
  final repo = ref.watch(roomRepositoryProvider);
  return repo.getRoomsByHotel(hotelId);
});

/// Danh sách loại phòng của khách sạn
final hotelRoomTypesProvider = FutureProvider.family<List<RoomTypeModel>, int>((ref, hotelId) async {
  final repo = ref.watch(roomRepositoryProvider);
  return repo.getRoomTypesByHotel(hotelId);
});

/// Query params tìm phòng trống
class AvailableRoomsParams {
  final int hotelId;
  final String checkIn;
  final String checkOut;
  final int? roomTypeId;

  const AvailableRoomsParams({
    required this.hotelId,
    required this.checkIn,
    required this.checkOut,
    this.roomTypeId,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AvailableRoomsParams &&
          runtimeType == other.runtimeType &&
          hotelId == other.hotelId &&
          checkIn == other.checkIn &&
          checkOut == other.checkOut &&
          roomTypeId == other.roomTypeId;

  @override
  int get hashCode =>
      hotelId.hashCode ^ checkIn.hashCode ^ checkOut.hashCode ^ roomTypeId.hashCode;
}

/// Danh sách phòng còn trống theo khoảng ngày check-in, check-out
final availableRoomsProvider = FutureProvider.family<List<RoomModel>, AvailableRoomsParams>((ref, params) async {
  final repo = ref.watch(roomRepositoryProvider);
  return repo.getAvailableRooms(
    params.hotelId,
    checkIn: params.checkIn,
    checkOut: params.checkOut,
    roomTypeId: params.roomTypeId,
  );
});

/// Chi tiết một phòng cụ thể
final roomDetailProvider = FutureProvider.family<RoomModel, int>((ref, id) async {
  final repo = ref.watch(roomRepositoryProvider);
  return repo.getRoomById(id);
});
