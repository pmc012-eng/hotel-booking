class ApiEndpoints {
  // Auth
  static const String register = '/auth/register';
  static const String login = '/auth/login';
  static const String me = '/auth/me';
  static const String updateProfile = '/auth/profile';
  static const String uploadAvatar = '/auth/avatar';
  static const String changePassword = '/auth/change-password';

  // Hotels
  static const String hotels = '/hotels';
  static const String featuredHotels = '/hotels/featured';
  static String hotelDetail(int id) => '/hotels/$id';

  // Rooms
  static String hotelRooms(int hotelId) => '/hotels/$hotelId/rooms';
  static String availableRooms(int hotelId) => '/hotels/$hotelId/available-rooms';
  static String roomDetail(int id) => '/rooms/$id';

  // Bookings
  static const String bookings = '/bookings';
  static const String myBookings = '/bookings/my-bookings';
  static String bookingDetail(int id) => '/bookings/$id';
  static String cancelBooking(int id) => '/bookings/$id/cancel';

  // Reviews
  static String hotelReviews(int hotelId) => '/hotels/$hotelId/reviews';

  // Admin
  static const String adminStats = '/admin/statistics';
  static const String adminUsers = '/admin/users';
  static const String adminBookings = '/admin/bookings';
  static String updateBookingStatus(int id) => '/admin/bookings/$id/status';

  // Upload
  static const String uploadImage = '/upload';
  static const String uploadMultipleImages = '/upload/multiple';
}
