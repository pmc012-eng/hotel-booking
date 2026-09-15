import 'package:intl/intl.dart';

class DateFormatter {
  static final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');
  static final DateFormat _apiDateFormat = DateFormat('yyyy-MM-dd');
  static final DateFormat _dateTimeFormat = DateFormat('HH:mm - dd/MM/yyyy');
  static final DateFormat _monthYearFormat = DateFormat('MMMM yyyy', 'vi');

  /// Định dạng ngày hiển thị (VD: 15/09/2026)
  static String formatDate(DateTime? date) {
    if (date == null) return '';
    return _dateFormat.format(date);
  }

  /// Định dạng ngày gửi lên API (VD: 2026-09-15)
  static String formatApiDate(DateTime? date) {
    if (date == null) return '';
    return _apiDateFormat.format(date);
  }

  /// Định dạng tháng năm (VD: Tháng 9 2026)
  static String formatMonthYear(DateTime? date) {
    if (date == null) return '';
    return _monthYearFormat.format(date);
  }

  /// Định dạng ngày và giờ (VD: 14:30 - 15/09/2026)
  static String formatDateTime(DateTime? date) {
    if (date == null) return '';
    return _dateTimeFormat.format(date);
  }

  /// Parse chuỗi từ API (chuỗi ISO hoặc yyyy-MM-dd)
  static DateTime? parse(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return null;
    return DateTime.tryParse(dateStr);
  }

  /// Tính số đêm giữa Check-in và Check-out
  static int calculateNights(DateTime checkIn, DateTime checkOut) {
    final difference = checkOut.difference(checkIn).inDays;
    return difference > 0 ? difference : 1;
  }
}
