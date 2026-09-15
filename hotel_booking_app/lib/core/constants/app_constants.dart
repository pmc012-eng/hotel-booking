import 'package:flutter/foundation.dart';

class AppConstants {
  static const String appName = 'Hotel Booking';
  static const String appVersion = '1.0.0';

  /// Cấu hình IP máy tính chạy Backend Node.js:
  /// - Chạy trên ĐIỆN THOẠI THẬT (chung Wi-Fi): Để IP Wi-Fi máy tính (192.168.88.176)
  /// - Chạy trên MÁY ẢO Android Studio: Dùng 192.168.88.176 hoặc 10.0.2.2
  /// - Chạy trên Web / Windows: Tự động kết nối localhost
  static String serverHost = '192.168.88.176';

  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:5000/api';
    }
    return 'http://$serverHost:5000/api';
  }

  /// Cấu hình Base URL cho ảnh static
  static String get imageBaseUrl {
    if (kIsWeb) {
      return 'http://localhost:5000';
    }
    return 'http://$serverHost:5000';
  }

  // Storage Keys
  static const String tokenKey = 'jwt_auth_token';
  static const String userKey = 'user_profile_cache';

  // Network timeouts
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);
}
