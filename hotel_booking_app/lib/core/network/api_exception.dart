import 'package:dio/dio.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;

  ApiException({
    required this.message,
    this.statusCode,
    this.data,
  });

  factory ApiException.fromDioError(DioException dioError) {
    switch (dioError.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiException(
          message: 'Kết nối mạng quá thời gian chờ. Vui lòng kiểm tra lại đường truyền!',
          statusCode: 408,
        );

      case DioExceptionType.connectionError:
        return ApiException(
          message: 'Không thể kết nối tới máy chủ. Vui lòng đảm bảo server backend đang chạy!',
          statusCode: 503,
        );

      case DioExceptionType.badResponse:
        final response = dioError.response;
        final statusCode = response?.statusCode;
        String message = 'Đã có lỗi xảy ra từ máy chủ ($statusCode)';

        if (response?.data is Map<String, dynamic>) {
          final data = response!.data as Map<String, dynamic>;
          if (data['message'] != null) {
            message = data['message'].toString();
          }
        }

        return ApiException(
          message: message,
          statusCode: statusCode,
          data: response?.data,
        );

      case DioExceptionType.cancel:
        return ApiException(message: 'Yêu cầu gọi API đã bị hủy!');

      default:
        return ApiException(
          message: 'Lỗi không xác định: ${dioError.message ?? "Vui lòng thử lại"}',
        );
    }
  }

  @override
  String toString() => message;
}
