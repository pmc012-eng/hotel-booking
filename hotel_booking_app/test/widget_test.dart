import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hotel_booking_app/main.dart';
import 'package:hotel_booking_app/models/hotel_model.dart';
import 'package:hotel_booking_app/models/room_model.dart';
import 'package:hotel_booking_app/models/booking_model.dart';
import 'package:hotel_booking_app/providers/hotel_provider.dart';
import 'package:hotel_booking_app/providers/room_provider.dart';
import 'package:hotel_booking_app/providers/booking_provider.dart';
import 'package:hotel_booking_app/screens/hotel/hotel_detail_screen.dart';
import 'package:hotel_booking_app/screens/main_wrapper/main_screen.dart';
import 'package:hotel_booking_app/screens/my_bookings/my_bookings_screen.dart';

void main() {
  final sampleHotel = HotelModel(
    id: 1,
    name: 'The Oriental Jade Hotel',
    address: '94 Hàng Trống',
    city: 'Hà Nội',
    star: 5,
    rating: 4.9,
    minPrice: 1350000,
    primaryImage: '/uploads/hotel_1.jpg',
  );

  testWidgets('App smoke test renders HotelBookingApp', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          featuredHotelsProvider.overrideWith((ref) async => [sampleHotel]),
          allHotelsProvider.overrideWith((ref) async => [sampleHotel]),
        ],
        child: const HotelBookingApp(),
      ),
    );
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();
    expect(find.byType(HotelBookingApp), findsOneWidget);
  });

  testWidgets('HotelDetailScreen renders correctly and scrolls without error', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          hotelDetailProvider(1).overrideWith((ref) async => sampleHotel),
          hotelRoomsProvider(1).overrideWith((ref) async => <RoomModel>[]),
        ],
        child: MaterialApp(
          home: HotelDetailScreen(hotelId: 1, hotel: sampleHotel),
        ),
      ),
    );
    await tester.pump();
    expect(find.byType(HotelDetailScreen), findsOneWidget);
    expect(find.text('The Oriental Jade Hotel'), findsOneWidget);
    expect(find.text('Chọn phòng ngay'), findsOneWidget);

    // Scroll down to ensure no layout/rendering errors
    await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -300));
    await tester.pump();
  });

  testWidgets('MainScreen initial tab index 2 renders MyBookingsScreen', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          myBookingsProvider(null).overrideWith((ref) async => <BookingModel>[]),
          featuredHotelsProvider.overrideWith((ref) async => [sampleHotel]),
          allHotelsProvider.overrideWith((ref) async => [sampleHotel]),
          searchHotelsProvider.overrideWith((ref) async => [sampleHotel]),
        ],
        child: const MaterialApp(
          home: MainScreen(initialIndex: 2),
        ),
      ),
    );
    await tester.pump();
    expect(find.byType(MyBookingsScreen), findsOneWidget);
  });

  testWidgets('MyBookingsScreen renders tabs and cards', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          myBookingsProvider(null).overrideWith((ref) async => <BookingModel>[]),
        ],
        child: const MaterialApp(
          home: MyBookingsScreen(initialBookings: <BookingModel>[]),
        ),
      ),
    );
    await tester.pump();
    expect(find.byType(MyBookingsScreen), findsOneWidget);
    expect(find.text('Đơn Đặt Phòng Của Tôi'), findsOneWidget);
    expect(find.text('Sắp tới'), findsOneWidget);
  });
}
