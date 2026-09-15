import 'package:dio/dio.dart';
import '../constants/app_constants.dart';
import '../../services/storage_service.dart';
import 'api_exception.dart';

class ApiClient {
  late final Dio _dio;

  ApiClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.baseUrl,
        connectTimeout: AppConstants.connectTimeout,
        receiveTimeout: AppConstants.receiveTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Tự động đính kèm Bearer token nếu đã lưu
          final token = await StorageService.getToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          return handler.next(response);
        },
        onError: (DioException e, handler) async {
          // Xử lý khi Token hết hạn (401)
          if (e.response?.statusCode == 401) {
            // Tự động xóa token lưu trữ để ép người dùng đăng nhập lại
            await StorageService.clearAll();
          }
          return handler.next(e);
        },
      ),
    );

    // Tự động nạp IP tùy chỉnh đã lưu nếu có
    StorageService.getServerHost().then((savedHost) {
      if (savedHost != null && savedHost.isNotEmpty) {
        updateBaseUrl(savedHost);
      }
    });
  }

  void updateBaseUrl(String newHost) {
    AppConstants.serverHost = newHost.trim();
    _dio.options.baseUrl = AppConstants.baseUrl;
  }

  Dio get dio => _dio;

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.get(path, queryParameters: queryParameters, options: options);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.post(path, data: data, queryParameters: queryParameters, options: options);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.put(path, data: data, queryParameters: queryParameters, options: options);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.delete(path, data: data, queryParameters: queryParameters, options: options);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }
}

// Singleton ApiClient instance
final apiClient = ApiClient();
