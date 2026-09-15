import 'package:intl/intl.dart';

class CurrencyFormatter {
  static final NumberFormat _vndFormat = NumberFormat.currency(
    locale: 'vi_VN',
    symbol: '₫',
    decimalDigits: 0,
  );

  /// Định dạng số tiền sang chuẩn Việt Nam Đồng (Ví dụ: 1.200.000 ₫)
  static String formatVND(dynamic amount) {
    if (amount == null) return '0 ₫';
    final num? value = num.tryParse(amount.toString());
    if (value == null) return '0 ₫';
    return _vndFormat.format(value).trim();
  }
}
