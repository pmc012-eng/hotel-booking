import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/app_constants.dart';
import '../models/user_model.dart';

class StorageService {
  static SharedPreferences? _prefs;

  static Future<SharedPreferences> get _instance async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  // Token
  static Future<bool> saveToken(String token) async {
    final prefs = await _instance;
    return prefs.setString(AppConstants.tokenKey, token);
  }

  static Future<String?> getToken() async {
    final prefs = await _instance;
    return prefs.getString(AppConstants.tokenKey);
  }

  static Future<bool> removeToken() async {
    final prefs = await _instance;
    return prefs.remove(AppConstants.tokenKey);
  }

  // User info cache
  static Future<bool> saveUser(UserModel user) async {
    final prefs = await _instance;
    final jsonStr = jsonEncode(user.toJson());
    return prefs.setString(AppConstants.userKey, jsonStr);
  }

  static Future<UserModel?> getUser() async {
    final prefs = await _instance;
    final jsonStr = prefs.getString(AppConstants.userKey);
    if (jsonStr == null || jsonStr.isEmpty) return null;
    try {
      final Map<String, dynamic> json = jsonDecode(jsonStr);
      return UserModel.fromJson(json);
    } catch (_) {
      return null;
    }
  }

  static Future<bool> removeUser() async {
    final prefs = await _instance;
    return prefs.remove(AppConstants.userKey);
  }

  static const String _serverHostKey = 'custom_server_host';

  static Future<bool> saveServerHost(String host) async {
    final prefs = await _instance;
    return prefs.setString(_serverHostKey, host.trim());
  }

  static Future<String?> getServerHost() async {
    final prefs = await _instance;
    return prefs.getString(_serverHostKey);
  }

  static Future<void> clearAll() async {
    final prefs = await _instance;
    await prefs.remove(AppConstants.tokenKey);
    await prefs.remove(AppConstants.userKey);
  }
}
