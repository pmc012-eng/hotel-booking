import 'dart:io';
import 'package:dio/dio.dart';
import '../core/constants/api_endpoints.dart';
import '../core/network/api_client.dart';
import '../models/user_model.dart';
import '../services/storage_service.dart';

class AuthRepository {
  final ApiClient _client;

  AuthRepository({ApiClient? client}) : _client = client ?? apiClient;

  /// Đăng nhập tài khoản
  Future<UserModel> login(String email, String password) async {
    final response = await _client.post(
      ApiEndpoints.login,
      data: {
        'email': email,
        'password': password,
      },
    );

    final data = response.data['data'] as Map<String, dynamic>;
    final token = data['token'] as String;
    final user = UserModel.fromJson(data['user'] as Map<String, dynamic>);

    // Lưu token và thông tin user vào SharedPreferences
    await StorageService.saveToken(token);
    await StorageService.saveUser(user);

    return user;
  }

  /// Đăng ký tài khoản mới
  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    final response = await _client.post(
      ApiEndpoints.register,
      data: {
        'name': name,
        'email': email,
        'password': password,
        'phone': phone,
      },
    );

    final data = response.data['data'] as Map<String, dynamic>;
    final token = data['token'] as String;
    final user = UserModel.fromJson(data['user'] as Map<String, dynamic>);

    await StorageService.saveToken(token);
    await StorageService.saveUser(user);

    return user;
  }

  /// Lấy thông tin tài khoản hiện tại từ API
  Future<UserModel?> getMe() async {
    try {
      final response = await _client.get(ApiEndpoints.me);
      final data = response.data['data']['user'] as Map<String, dynamic>;
      final user = UserModel.fromJson(data);
      await StorageService.saveUser(user);
      return user;
    } catch (_) {
      return null;
    }
  }

  /// Cập nhật hồ sơ
  Future<UserModel> updateProfile({required String name, required String phone, String? avatar}) async {
    final body = <String, dynamic>{
      'name': name,
      'phone': phone,
    };
    if (avatar != null) {
      body['avatar'] = avatar;
    }

    final response = await _client.put(
      ApiEndpoints.updateProfile,
      data: body,
    );

    final data = response.data['data']['user'] as Map<String, dynamic>;
    final user = UserModel.fromJson(data);
    await StorageService.saveUser(user);
    return user;
  }

  /// Tải lên và cập nhật ảnh đại diện người dùng
  Future<UserModel> uploadAvatar(File imageFile) async {
    final fileName = imageFile.path.split(Platform.pathSeparator).last;
    final formData = FormData.fromMap({
      'avatar': await MultipartFile.fromFile(
        imageFile.path,
        filename: fileName,
      ),
    });

    final response = await _client.put(
      ApiEndpoints.uploadAvatar,
      data: formData,
    );

    final data = response.data['data']['user'] as Map<String, dynamic>;
    final user = UserModel.fromJson(data);
    await StorageService.saveUser(user);
    return user;
  }

  /// Đổi mật khẩu
  Future<bool> changePassword({required String oldPassword, required String newPassword}) async {
    await _client.put(
      ApiEndpoints.changePassword,
      data: {
        'oldPassword': oldPassword,
        'newPassword': newPassword,
      },
    );
    return true;
  }

  /// Đăng xuất
  Future<void> logout() async {
    await StorageService.clearAll();
  }
}

final authRepository = AuthRepository();
