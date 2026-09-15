import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../core/network/api_exception.dart';
import '../models/booking_model.dart';
import '../repositories/booking_repository.dart';

final bookingRepositoryProvider = Provider<BookingRepository>((ref) {
  return bookingRepository;
});

/// Danh sách booking của người dùng hiện tại (lọc theo status nếu có)
final myBookingsProvider = FutureProvider.family<List<BookingModel>, String?>((ref, status) async {
  final repo = ref.watch(bookingRepositoryProvider);
  return repo.getMyBookings(status: status);
});

/// Chi tiết một booking theo ID
final bookingDetailProvider = FutureProvider.family<BookingModel, int>((ref, id) async {
  final repo = ref.watch(bookingRepositoryProvider);
  return repo.getBookingById(id);
});

class BookingActionState {
  final bool isLoading;
  final String? errorMessage;
  final BookingModel? lastBooking;

  const BookingActionState({
    this.isLoading = false,
    this.errorMessage,
    this.lastBooking,
  });

  BookingActionState copyWith({
    bool? isLoading,
    String? errorMessage,
    BookingModel? lastBooking,
    bool clearError = false,
  }) {
    return BookingActionState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      lastBooking: lastBooking ?? this.lastBooking,
    );
  }
}

class BookingActionNotifier extends StateNotifier<BookingActionState> {
  final BookingRepository _repo;
  final Ref _ref;

  BookingActionNotifier(this._repo, this._ref) : super(const BookingActionState());

  /// Tạo đơn đặt phòng
  Future<BookingModel?> createBooking({
    required int roomId,
    required String checkIn,
    required String checkOut,
    required String guestName,
    required String guestPhone,
    required String guestEmail,
    String paymentMethod = 'PAY_AT_HOTEL',
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final booking = await _repo.createBooking(
        roomId: roomId,
        checkIn: checkIn,
        checkOut: checkOut,
        guestName: guestName,
        guestPhone: guestPhone,
        guestEmail: guestEmail,
        paymentMethod: paymentMethod,
      );
      state = state.copyWith(isLoading: false, lastBooking: booking);
      // Invalidate myBookings để refresh danh sách
      _ref.invalidate(myBookingsProvider);
      return booking;
    } on ApiException catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.message);
      return null;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Đặt phòng không thành công. Vui lòng thử lại!',
      );
      return null;
    }
  }

  /// Hủy đơn đặt phòng
  Future<bool> cancelBooking(int id) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final cancelled = await _repo.cancelBooking(id);
      state = state.copyWith(isLoading: false, lastBooking: cancelled);
      _ref.invalidate(myBookingsProvider);
      _ref.invalidate(bookingDetailProvider(id));
      return true;
    } on ApiException catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.message);
      return false;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Hủy đơn thất bại. Vui lòng thử lại!',
      );
      return false;
    }
  }

  void clearError() {
    state = state.copyWith(clearError: true);
  }
}

final bookingActionProvider = StateNotifierProvider<BookingActionNotifier, BookingActionState>((ref) {
  final repo = ref.watch(bookingRepositoryProvider);
  return BookingActionNotifier(repo, ref);
});
