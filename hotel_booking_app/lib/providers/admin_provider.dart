import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../core/network/api_exception.dart';
import '../models/admin_stats_model.dart';
import '../models/booking_model.dart';
import '../models/hotel_model.dart';
import '../models/room_model.dart';
import '../models/user_model.dart';
import '../repositories/admin_repository.dart';
import 'hotel_provider.dart';
import 'room_provider.dart';

final adminRepositoryProvider = Provider<AdminRepository>((ref) {
  return adminRepository;
});

/// Thống kê Dashboard Admin
final adminStatsProvider = FutureProvider<AdminStatsModel>((ref) async {
  final repo = ref.watch(adminRepositoryProvider);
  return repo.getStatistics();
});

/// Toàn bộ đơn đặt phòng cho Admin (lọc theo trạng thái)
final adminBookingsProvider = FutureProvider.family<List<BookingModel>, String?>((ref, status) async {
  final repo = ref.watch(adminRepositoryProvider);
  return repo.getAllBookings(status: status);
});

/// Danh sách toàn bộ người dùng
final adminUsersProvider = FutureProvider<List<UserModel>>((ref) async {
  final repo = ref.watch(adminRepositoryProvider);
  return repo.getAllUsers();
});

class AdminActionState {
  final bool isLoading;
  final String? errorMessage;
  final String? successMessage;

  const AdminActionState({
    this.isLoading = false,
    this.errorMessage,
    this.successMessage,
  });

  AdminActionState copyWith({
    bool? isLoading,
    String? errorMessage,
    String? successMessage,
    bool clearError = false,
    bool clearSuccess = false,
  }) {
    return AdminActionState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      successMessage: clearSuccess ? null : (successMessage ?? this.successMessage),
    );
  }
}

class AdminActionNotifier extends StateNotifier<AdminActionState> {
  final AdminRepository _repo;
  final Ref _ref;

  AdminActionNotifier(this._repo, this._ref) : super(const AdminActionState());

  /// Cập nhật trạng thái đơn đặt phòng
  Future<bool> updateBookingStatus(int id, String status) async {
    state = state.copyWith(isLoading: true, clearError: true, clearSuccess: true);
    try {
      await _repo.updateBookingStatus(id, status);
      state = state.copyWith(isLoading: false, successMessage: 'Đã cập nhật trạng thái đơn thành $status!');
      _ref.invalidate(adminStatsProvider);
      _ref.invalidate(adminBookingsProvider);
      return true;
    } on ApiException catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.message);
      return false;
    } catch (_) {
      state = state.copyWith(isLoading: false, errorMessage: 'Cập nhật trạng thái thất bại!');
      return false;
    }
  }

  /// Thêm khách sạn mới
  Future<HotelModel?> createHotel(Map<String, dynamic> hotelData) async {
    state = state.copyWith(isLoading: true, clearError: true, clearSuccess: true);
    try {
      final hotel = await _repo.createHotel(hotelData);
      state = state.copyWith(isLoading: false, successMessage: 'Thêm khách sạn mới thành công!');
      _ref.invalidate(adminStatsProvider);
      _ref.invalidate(allHotelsProvider);
      _ref.invalidate(featuredHotelsProvider);
      _ref.invalidate(searchHotelsProvider);
      return hotel;
    } on ApiException catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.message);
      return null;
    } catch (_) {
      state = state.copyWith(isLoading: false, errorMessage: 'Thêm khách sạn thất bại!');
      return null;
    }
  }

  /// Xóa khách sạn
  Future<bool> deleteHotel(int id) async {
    state = state.copyWith(isLoading: true, clearError: true, clearSuccess: true);
    try {
      await _repo.deleteHotel(id);
      state = state.copyWith(isLoading: false, successMessage: 'Đã xóa khách sạn thành công!');
      _ref.invalidate(adminStatsProvider);
      _ref.invalidate(allHotelsProvider);
      _ref.invalidate(featuredHotelsProvider);
      _ref.invalidate(searchHotelsProvider);
      return true;
    } on ApiException catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.message);
      return false;
    } catch (_) {
      state = state.copyWith(isLoading: false, errorMessage: 'Xóa khách sạn thất bại!');
      return false;
    }
  }

  /// Thêm phòng mới cho khách sạn
  Future<RoomModel?> createRoom(Map<String, dynamic> roomData) async {
    state = state.copyWith(isLoading: true, clearError: true, clearSuccess: true);
    try {
      final room = await _repo.createRoom(roomData);
      state = state.copyWith(isLoading: false, successMessage: 'Đã thêm phòng thành công!');
      final hotelId = roomData['hotelId'] as int?;
      if (hotelId != null) {
        _ref.invalidate(hotelRoomsProvider(hotelId));
        _ref.invalidate(hotelDetailProvider(hotelId));
      }
      _ref.invalidate(adminStatsProvider);
      _ref.invalidate(allHotelsProvider);
      _ref.invalidate(featuredHotelsProvider);
      _ref.invalidate(searchHotelsProvider);
      return room;
    } on ApiException catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.message);
      return null;
    } catch (_) {
      state = state.copyWith(isLoading: false, errorMessage: 'Thêm phòng thất bại!');
      return null;
    }
  }

  /// Xóa phòng
  Future<bool> deleteRoom(int id, int hotelId) async {
    state = state.copyWith(isLoading: true, clearError: true, clearSuccess: true);
    try {
      await _repo.deleteRoom(id);
      state = state.copyWith(isLoading: false, successMessage: 'Đã xóa phòng thành công!');
      _ref.invalidate(hotelRoomsProvider(hotelId));
      _ref.invalidate(hotelDetailProvider(hotelId));
      _ref.invalidate(adminStatsProvider);
      _ref.invalidate(allHotelsProvider);
      _ref.invalidate(featuredHotelsProvider);
      _ref.invalidate(searchHotelsProvider);
      return true;
    } on ApiException catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.message);
      return false;
    } catch (_) {
      state = state.copyWith(isLoading: false, errorMessage: 'Xóa phòng thất bại!');
      return false;
    }
  }

  /// Cập nhật trạng thái phòng (AVAILABLE / MAINTENANCE)
  Future<bool> updateRoomStatus(int id, int hotelId, String newStatus) async {
    state = state.copyWith(isLoading: true, clearError: true, clearSuccess: true);
    try {
      await _repo.updateRoom(id, {'status': newStatus});
      state = state.copyWith(isLoading: false, successMessage: 'Đã cập nhật trạng thái phòng!');
      _ref.invalidate(adminStatsProvider);
      _ref.invalidate(hotelRoomsProvider(hotelId));
      return true;
    } on ApiException catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.message);
      return false;
    } catch (_) {
      state = state.copyWith(isLoading: false, errorMessage: 'Cập nhật trạng thái phòng thất bại!');
      return false;
    }
  }

  /// Tải lên ảnh từ điện thoại
  Future<String?> uploadImage(File imageFile, {String type = 'general'}) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final url = await _repo.uploadImage(imageFile, type: type);
      state = state.copyWith(isLoading: false);
      return url;
    } on ApiException catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.message);
      return null;
    } catch (_) {
      state = state.copyWith(isLoading: false, errorMessage: 'Tải ảnh lên thất bại!');
      return null;
    }
  }
}

final adminActionProvider = StateNotifierProvider<AdminActionNotifier, AdminActionState>((ref) {
  final repo = ref.watch(adminRepositoryProvider);
  return AdminActionNotifier(repo, ref);
});
