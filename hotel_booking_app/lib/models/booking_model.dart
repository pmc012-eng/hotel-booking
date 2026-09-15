import '../core/constants/app_constants.dart';

class BookingModel {
  final int id;
  final String bookingCode;
  final int userId;
  final int roomId;
  final String checkIn;
  final String checkOut;
  final String guestName;
  final String guestPhone;
  final String guestEmail;
  final double totalPrice;
  final String status;
  final String paymentMethod;
  final String paymentStatus;
  final DateTime? createdAt;

  // Thuộc tính mở rộng từ JOIN
  final int? hotelId;
  final String? hotelName;
  final String? hotelAddress;
  final String? hotelCity;
  final int? hotelStar;
  final String? hotelImage;
  final String? roomNumber;
  final String? roomTypeName;
  final double? pricePerNight;
  final int numberOfNights;

  BookingModel({
    required this.id,
    required this.bookingCode,
    required this.userId,
    required this.roomId,
    required this.checkIn,
    required this.checkOut,
    required this.guestName,
    required this.guestPhone,
    required this.guestEmail,
    required this.totalPrice,
    required this.status,
    this.paymentMethod = 'PAY_AT_HOTEL',
    this.paymentStatus = 'UNPAID',
    this.createdAt,
    this.hotelId,
    this.hotelName,
    this.hotelAddress,
    this.hotelCity,
    this.hotelStar,
    this.hotelImage,
    this.roomNumber,
    this.roomTypeName,
    this.pricePerNight,
    this.numberOfNights = 1,
  });

  bool get isConfirmed => status == 'CONFIRMED';
  bool get isCompleted => status == 'COMPLETED';
  bool get isCancelled => status == 'CANCELLED';

  String get fullHotelImageUrl {
    if (hotelImage == null || hotelImage!.trim().isEmpty) {
      return 'https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=800&q=80';
    }
    final trimmed = hotelImage!.trim();
    if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
      return trimmed;
    }
    return '${AppConstants.imageBaseUrl}$trimmed';
  }

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      bookingCode: json['booking_code']?.toString() ?? '',
      userId: json['user_id'] is int ? json['user_id'] : int.tryParse(json['user_id']?.toString() ?? '0') ?? 0,
      roomId: json['room_id'] is int ? json['room_id'] : int.tryParse(json['room_id']?.toString() ?? '0') ?? 0,
      checkIn: json['check_in'] != null ? json['check_in'].toString().split('T')[0] : '',
      checkOut: json['check_out'] != null ? json['check_out'].toString().split('T')[0] : '',
      guestName: json['guest_name']?.toString() ?? '',
      guestPhone: json['guest_phone']?.toString() ?? '',
      guestEmail: json['guest_email']?.toString() ?? '',
      totalPrice: double.tryParse(json['total_price']?.toString() ?? '0') ?? 0.0,
      status: json['status']?.toString() ?? 'CONFIRMED',
      paymentMethod: json['payment_method']?.toString() ?? 'PAY_AT_HOTEL',
      paymentStatus: json['payment_status']?.toString() ?? 'UNPAID',
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at'].toString()) : null,
      hotelId: json['hotel_id'] != null
          ? (json['hotel_id'] is int ? json['hotel_id'] : int.tryParse(json['hotel_id']?.toString() ?? '0'))
          : null,
      hotelName: json['hotel_name']?.toString(),
      hotelAddress: json['hotel_address']?.toString(),
      hotelCity: json['hotel_city']?.toString(),
      hotelStar: json['hotel_star'] != null
          ? (json['hotel_star'] is int ? json['hotel_star'] : int.tryParse(json['hotel_star'].toString()) ?? 4)
          : 4,
      hotelImage: json['hotel_image']?.toString(),
      roomNumber: json['room_number']?.toString(),
      roomTypeName: json['room_type_name']?.toString(),
      pricePerNight: double.tryParse(json['price_per_night']?.toString() ?? '0'),
      numberOfNights: json['number_of_nights'] != null
          ? (json['number_of_nights'] is int
              ? json['number_of_nights']
              : int.tryParse(json['number_of_nights'].toString()) ?? 1)
          : 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'booking_code': bookingCode,
      'user_id': userId,
      'room_id': roomId,
      'check_in': checkIn,
      'check_out': checkOut,
      'guest_name': guestName,
      'guest_phone': guestPhone,
      'guest_email': guestEmail,
      'total_price': totalPrice,
      'status': status,
      'payment_method': paymentMethod,
      'payment_status': paymentStatus,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}
