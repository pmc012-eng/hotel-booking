import '../core/constants/api_endpoints.dart';
import '../core/network/api_client.dart';
import '../models/booking_model.dart';

class BookingRepository {
  final ApiClient _client;

  BookingRepository({ApiClient? client}) : _client = client ?? apiClient;

  /// Tạo đơn đặt phòng mới
  Future<BookingModel> createBooking({
    required int roomId,
    required String checkIn,
    required String checkOut,
    required String guestName,
    required String guestPhone,
    required String guestEmail,
    String paymentMethod = 'PAY_AT_HOTEL',
  }) async {
    final response = await _client.post(
      ApiEndpoints.bookings,
      data: {
        'roomId': roomId,
        'checkIn': checkIn,
        'checkOut': checkOut,
        'guestName': guestName,
        'guestPhone': guestPhone,
        'guestEmail': guestEmail,
        'paymentMethod': paymentMethod,
      },
    );

    final data = response.data['data'] as Map<String, dynamic>;
    return BookingModel.fromJson(data);
  }

  /// Lấy danh sách booking của người dùng hiện tại
  Future<List<BookingModel>> getMyBookings({String? status}) async {
    final queryParams = <String, dynamic>{};
    if (status != null && status.isNotEmpty && status != 'ALL') {
      queryParams['status'] = status;
    }

    final response = await _client.get(
      ApiEndpoints.myBookings,
      queryParameters: queryParams,
    );
    final rawData = response.data['data'];
    if (rawData is List) {
      return rawData
          .whereType<Map<String, dynamic>>()
          .map((item) => BookingModel.fromJson(item))
          .toList();
    }
    return [];
  }

  /// Lấy chi tiết một booking
  Future<BookingModel> getBookingById(int id) async {
    final response = await _client.get(ApiEndpoints.bookingDetail(id));
    final data = response.data['data'] as Map<String, dynamic>;
    return BookingModel.fromJson(data);
  }

  /// Hủy một booking
  Future<BookingModel> cancelBooking(int id) async {
    final response = await _client.put(ApiEndpoints.cancelBooking(id));
    final data = response.data['data'] as Map<String, dynamic>;
    return BookingModel.fromJson(data);
  }
}

final bookingRepository = BookingRepository();
