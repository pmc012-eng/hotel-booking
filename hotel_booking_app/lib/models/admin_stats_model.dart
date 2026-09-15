class AdminRecentBookingModel {
  final int id;
  final String bookingCode;
  final String guestName;
  final String checkIn;
  final String checkOut;
  final double totalPrice;
  final String status;
  final String hotelName;
  final String roomNumber;

  AdminRecentBookingModel({
    required this.id,
    required this.bookingCode,
    required this.guestName,
    required this.checkIn,
    required this.checkOut,
    required this.totalPrice,
    required this.status,
    required this.hotelName,
    required this.roomNumber,
  });

  factory AdminRecentBookingModel.fromJson(Map<String, dynamic> json) {
    return AdminRecentBookingModel(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      bookingCode: json['booking_code'] ?? '',
      guestName: json['guest_name'] ?? '',
      checkIn: json['check_in'] != null ? json['check_in'].toString().split('T')[0] : '',
      checkOut: json['check_out'] != null ? json['check_out'].toString().split('T')[0] : '',
      totalPrice: double.tryParse(json['total_price']?.toString() ?? '0') ?? 0.0,
      status: json['status'] ?? 'CONFIRMED',
      hotelName: json['hotel_name'] ?? '',
      roomNumber: json['room_number']?.toString() ?? '',
    );
  }
}

class AdminStatsModel {
  final double revenue;
  final int totalBookings;
  final int confirmedBookings;
  final int completedBookings;
  final int cancelledBookings;
  final int totalHotels;
  final int totalRooms;
  final int availableRooms;
  final int maintenanceRooms;
  final int totalUsers;
  final List<AdminRecentBookingModel> recentBookings;

  AdminStatsModel({
    required this.revenue,
    required this.totalBookings,
    required this.confirmedBookings,
    required this.completedBookings,
    required this.cancelledBookings,
    required this.totalHotels,
    required this.totalRooms,
    required this.availableRooms,
    required this.maintenanceRooms,
    required this.totalUsers,
    required this.recentBookings,
  });

  factory AdminStatsModel.fromJson(Map<String, dynamic> json) {
    final bookings = json['bookings'] as Map<String, dynamic>? ?? {};
    final hotels = json['hotels'] as Map<String, dynamic>? ?? {};
    final rooms = json['rooms'] as Map<String, dynamic>? ?? {};
    final users = json['users'] as Map<String, dynamic>? ?? {};

    final recentList = json['recentBookings'] as List? ?? [];

    return AdminStatsModel(
      revenue: double.tryParse(json['revenue']?.toString() ?? '0') ?? 0.0,
      totalBookings: int.tryParse(bookings['total']?.toString() ?? '0') ?? 0,
      confirmedBookings: int.tryParse(bookings['confirmed']?.toString() ?? '0') ?? 0,
      completedBookings: int.tryParse(bookings['completed']?.toString() ?? '0') ?? 0,
      cancelledBookings: int.tryParse(bookings['cancelled']?.toString() ?? '0') ?? 0,
      totalHotels: int.tryParse(hotels['total']?.toString() ?? '0') ?? 0,
      totalRooms: int.tryParse(rooms['total']?.toString() ?? '0') ?? 0,
      availableRooms: int.tryParse(rooms['available']?.toString() ?? '0') ?? 0,
      maintenanceRooms: int.tryParse(rooms['maintenance']?.toString() ?? '0') ?? 0,
      totalUsers: int.tryParse(users['total']?.toString() ?? '0') ?? 0,
      recentBookings: recentList
          .map((item) => AdminRecentBookingModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}
