import 'package:flutter_test/flutter_test.dart';
import 'package:hotel_booking_app/models/user_model.dart';
import 'package:hotel_booking_app/models/hotel_model.dart';
import 'package:hotel_booking_app/models/room_model.dart';
import 'package:hotel_booking_app/models/booking_model.dart';
import 'package:hotel_booking_app/models/admin_stats_model.dart';
import 'package:hotel_booking_app/core/network/api_exception.dart';
import 'package:dio/dio.dart';

void main() {
  group('Model Serialization Tests', () {
    test('UserModel fromJson and toJson work correctly', () {
      final json = {
        'id': 1,
        'name': 'Nguyễn Văn A',
        'email': 'user1@gmail.com',
        'phone': '0912345678',
        'role': 'USER',
        'avatar': '/uploads/avatar.jpg',
      };

      final user = UserModel.fromJson(json);
      expect(user.id, 1);
      expect(user.name, 'Nguyễn Văn A');
      expect(user.isAdmin, false);
      expect(user.toJson()['email'], 'user1@gmail.com');
      expect(user.fullAvatarUrl?.contains('/uploads/avatar.jpg'), true);
    });

    test('HotelModel parses image URLs and price correctly', () {
      final json = {
        'id': 10,
        'name': 'Luxury Palace',
        'address': '123 Đường Biển',
        'city': 'Đà Nẵng',
        'star': 5,
        'rating': '4.85',
        'min_price': '1500000',
        'primary_image': '/uploads/hotel_1.jpg',
        'review_count': '32',
      };

      final hotel = HotelModel.fromJson(json);
      expect(hotel.id, 10);
      expect(hotel.star, 5);
      expect(hotel.rating, 4.85);
      expect(hotel.minPrice, 1500000.0);
      expect(hotel.fullPrimaryImageUrl.contains('/uploads/hotel_1.jpg'), true);
    });

    test('RoomModel parses status, amenities and image URL correctly', () {
      final json = {
        'id': 201,
        'hotel_id': 1,
        'room_type_id': 2,
        'room_number': '201',
        'status': 'AVAILABLE',
        'room_type_name': 'Deluxe View',
        'capacity': 2,
        'price': 1200000,
        'image_url': '/uploads/rooms/room_custom.jpg',
        'amenities': ['Wifi', 'Điều hòa', 'TV'],
      };

      final room = RoomModel.fromJson(json);
      expect(room.id, 201);
      expect(room.isAvailable, true);
      expect(room.amenities.length, 3);
      expect(room.price, 1200000.0);
      expect(room.fullImageUrl.contains('/uploads/rooms/room_custom.jpg'), true);
    });

    test('BookingModel calculated properties and status work correctly', () {
      final json = {
        'id': 55,
        'booking_code': 'HB-2026-9999',
        'user_id': 1,
        'room_id': 201,
        'check_in': '2026-10-01T00:00:00.000Z',
        'check_out': '2026-10-03T00:00:00.000Z',
        'guest_name': 'Nguyễn Văn A',
        'guest_phone': '0912345678',
        'guest_email': 'user1@gmail.com',
        'total_price': 2400000,
        'status': 'CONFIRMED',
        'number_of_nights': 2,
      };

      final booking = BookingModel.fromJson(json);
      expect(booking.id, 55);
      expect(booking.checkIn, '2026-10-01');
      expect(booking.checkOut, '2026-10-03');
      expect(booking.isConfirmed, true);
      expect(booking.isCancelled, false);
      expect(booking.numberOfNights, 2);
    });

    test('AdminStatsModel parses KPI figures accurately', () {
      final json = {
        'revenue': '15500000',
        'bookings': {
          'total': '12',
          'confirmed': '5',
          'completed': '6',
          'cancelled': '1',
        },
        'hotels': {'total': '10'},
        'rooms': {
          'total': '47',
          'available': '45',
          'maintenance': '2',
        },
        'users': {'total': '28'},
        'recentBookings': [
          {
            'id': 1,
            'booking_code': 'HB-2026-1234',
            'guest_name': 'Lê Văn C',
            'check_in': '2026-11-01',
            'check_out': '2026-11-03',
            'total_price': '2500000',
            'status': 'CONFIRMED',
            'hotel_name': 'Oriental Jade',
            'room_number': '101',
          }
        ],
      };

      final stats = AdminStatsModel.fromJson(json);
      expect(stats.revenue, 15500000.0);
      expect(stats.totalBookings, 12);
      expect(stats.confirmedBookings, 5);
      expect(stats.totalHotels, 10);
      expect(stats.availableRooms, 45);
      expect(stats.maintenanceRooms, 2);
      expect(stats.recentBookings.length, 1);
      expect(stats.recentBookings[0].bookingCode, 'HB-2026-1234');
    });
  });

  group('ApiException Tests', () {
    test('ApiException extracts message from Dio badResponse', () {
      final response = Response(
        requestOptions: RequestOptions(path: '/test'),
        statusCode: 400,
        data: {'status': 'fail', 'message': 'Email đã được sử dụng!'},
      );

      final dioError = DioException(
        requestOptions: RequestOptions(path: '/test'),
        response: response,
        type: DioExceptionType.badResponse,
      );

      final apiException = ApiException.fromDioError(dioError);
      expect(apiException.statusCode, 400);
      expect(apiException.message, 'Email đã được sử dụng!');
    });

    test('ApiException handles network connection error', () {
      final dioError = DioException(
        requestOptions: RequestOptions(path: '/test'),
        type: DioExceptionType.connectionError,
      );

      final apiException = ApiException.fromDioError(dioError);
      expect(apiException.message.contains('Không thể kết nối'), true);
    });
  });
}
