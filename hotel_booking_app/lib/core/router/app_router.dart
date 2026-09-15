import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../models/booking_model.dart';
import '../../models/hotel_model.dart';
import '../../models/room_model.dart';
import '../../screens/splash/splash_screen.dart';
import '../../screens/auth/login_screen.dart';
import '../../screens/auth/register_screen.dart';
import '../../screens/main_wrapper/main_screen.dart';
import '../../screens/explore/explore_screen.dart';
import '../../screens/hotel/hotel_detail_screen.dart';
import '../../screens/booking/booking_create_screen.dart';
import '../../screens/booking/booking_summary_screen.dart';
import '../../screens/booking/booking_success_screen.dart';
import '../../screens/my_bookings/my_bookings_screen.dart';
import '../../screens/my_bookings/booking_detail_screen.dart';
import '../../screens/profile/edit_profile_screen.dart';
import '../../screens/profile/change_password_screen.dart';
import '../../screens/admin/admin_dashboard_screen.dart';
import '../../screens/admin/admin_booking_manage_screen.dart';
import '../../screens/admin/admin_hotel_manage_screen.dart';
import '../../screens/admin/admin_room_manage_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/main',
      builder: (context, state) {
        final tabIndex = int.tryParse(state.uri.queryParameters['tab'] ?? '0') ?? 0;
        return MainScreen(initialIndex: tabIndex);
      },
    ),
    GoRoute(
      path: '/explore',
      builder: (context, state) => const ExploreScreen(),
    ),
    GoRoute(
      path: '/my-bookings',
      builder: (context, state) => const MyBookingsScreen(),
    ),
    GoRoute(
      path: '/hotel/:id',
      builder: (context, state) {
        final id = int.tryParse(state.pathParameters['id'] ?? '1') ?? 1;
        HotelModel? hotel;
        if (state.extra is HotelModel) {
          hotel = state.extra as HotelModel;
        } else if (state.extra is Map<String, dynamic>) {
          hotel = HotelModel.fromJson(state.extra as Map<String, dynamic>);
        }
        return HotelDetailScreen(hotelId: id, hotel: hotel);
      },
    ),
    GoRoute(
      path: '/booking/create',
      builder: (context, state) {
        final extra = state.extra is Map<String, dynamic> ? state.extra as Map<String, dynamic> : null;
        if (extra == null || extra['hotel'] == null || extra['room'] == null) {
          return const MainScreen();
        }
        return BookingCreateScreen(
          hotel: extra['hotel'] as HotelModel,
          room: extra['room'] as RoomModel,
        );
      },
    ),
    GoRoute(
      path: '/booking/summary',
      builder: (context, state) {
        final extra = state.extra is Map<String, dynamic> ? state.extra as Map<String, dynamic> : null;
        if (extra == null || extra['hotel'] == null || extra['room'] == null) {
          return const MainScreen();
        }
        return BookingSummaryScreen(
          hotel: extra['hotel'] as HotelModel,
          room: extra['room'] as RoomModel,
          checkIn: extra['checkIn'] as DateTime? ?? DateTime.now(),
          checkOut: extra['checkOut'] as DateTime? ?? DateTime.now().add(const Duration(days: 1)),
          guestName: extra['guestName']?.toString() ?? '',
          guestPhone: extra['guestPhone']?.toString() ?? '',
          guestEmail: extra['guestEmail']?.toString() ?? '',
          notes: extra['notes']?.toString(),
          paymentMethod: extra['paymentMethod']?.toString() ?? 'PAY_AT_HOTEL',
          numberOfNights: (extra['numberOfNights'] as num?)?.toInt() ?? 1,
          totalPrice: (extra['totalPrice'] as num?)?.toDouble() ?? 0.0,
        );
      },
    ),
    GoRoute(
      path: '/booking/success',
      builder: (context, state) {
        final extra = state.extra is Map<String, dynamic> ? state.extra as Map<String, dynamic> : null;
        if (extra == null) return const MainScreen();
        return BookingSuccessScreen(
          bookingCode: extra['bookingCode']?.toString() ?? 'BK-DEFAULT',
          hotelName: extra['hotelName']?.toString() ?? 'Khách sạn',
          totalPrice: (extra['totalPrice'] as num?)?.toDouble() ?? 0.0,
        );
      },
    ),
    GoRoute(
      path: '/booking/detail/:id',
      builder: (context, state) {
        final id = int.tryParse(state.pathParameters['id'] ?? '1') ?? 1;
        final booking = state.extra is BookingModel ? state.extra as BookingModel : null;
        return BookingDetailScreen(bookingId: id, initialBooking: booking);
      },
    ),
    GoRoute(
      path: '/profile/edit',
      builder: (context, state) => const EditProfileScreen(),
    ),
    GoRoute(
      path: '/profile/change-password',
      builder: (context, state) => const ChangePasswordScreen(),
    ),
    // Admin Routes
    GoRoute(
      path: '/admin',
      builder: (context, state) => const AdminDashboardScreen(),
    ),
    GoRoute(
      path: '/admin/bookings',
      builder: (context, state) => const AdminBookingManageScreen(),
    ),
    GoRoute(
      path: '/admin/hotels',
      builder: (context, state) => const AdminHotelManageScreen(),
    ),
    GoRoute(
      path: '/admin/rooms',
      builder: (context, state) {
        int? initialHotelId;
        if (state.extra is int) {
          initialHotelId = state.extra as int;
        } else if (state.uri.queryParameters['hotelId'] != null) {
          initialHotelId = int.tryParse(state.uri.queryParameters['hotelId']!);
        }
        return AdminRoomManageScreen(initialHotelId: initialHotelId);
      },
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Text('Không tìm thấy trang: ${state.uri.toString()}'),
    ),
  ),
);
