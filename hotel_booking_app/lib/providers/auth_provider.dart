import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../core/network/api_exception.dart';
import '../models/user_model.dart';
import '../repositories/auth_repository.dart';
import '../services/storage_service.dart';

class AuthState {
  final UserModel? user;
  final String? token;
  final bool isLoading;
  final String? errorMessage;
  final bool isInitialized;

  const AuthState({
    this.user,
    this.token,
    this.isLoading = false,
    this.errorMessage,
    this.isInitialized = false,
  });

  bool get isAuthenticated => user != null && token != null;
  bool get isAdmin => user?.isAdmin ?? false;

  AuthState copyWith({
    UserModel? user,
    String? token,
    bool? isLoading,
    String? errorMessage,
    bool? isInitialized,
    bool clearUser = false,
    bool clearError = false,
  }) {
    return AuthState(
      user: clearUser ? null : (user ?? this.user),
      token: clearUser ? null : (token ?? this.token),
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      isInitialized: isInitialized ?? this.isInitialized,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repo;

  AuthNotifier(this._repo) : super(const AuthState()) {
    init();
  }

  Future<void> init() async {
    final token = await StorageService.getToken();
    final cachedUser = await StorageService.getUser();
    if (token != null && cachedUser != null) {
      state = state.copyWith(user: cachedUser, token: token, isInitialized: true);
      try {
        final freshUser = await _repo.getMe();
        if (freshUser != null) {
          state = state.copyWith(user: freshUser);
        }
      } catch (_) {}
    } else {
      state = state.copyWith(isInitialized: true);
    }
  }

  Future<bool> login(String email, String password) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final user = await _repo.login(email, password);
      final token = await StorageService.getToken();
      state = state.copyWith(user: user, token: token, isLoading: false);
      return true;
    } on ApiException catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.message);
      return false;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: 'Đã xảy ra lỗi không xác định');
      return false;
    }
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final user = await _repo.register(
        name: name,
        email: email,
        password: password,
        phone: phone,
      );
      final token = await StorageService.getToken();
      state = state.copyWith(user: user, token: token, isLoading: false);
      return true;
    } on ApiException catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.message);
      return false;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: 'Đã xảy ra lỗi không xác định');
      return false;
    }
  }

  Future<bool> updateProfile({required String name, required String phone, String? avatar}) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final updatedUser = await _repo.updateProfile(name: name, phone: phone, avatar: avatar);
      state = state.copyWith(user: updatedUser, isLoading: false);
      return true;
    } on ApiException catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.message);
      return false;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: 'Cập nhật thất bại');
      return false;
    }
  }

  Future<bool> changePassword({required String oldPassword, required String newPassword}) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await _repo.changePassword(oldPassword: oldPassword, newPassword: newPassword);
      state = state.copyWith(isLoading: false);
      return true;
    } on ApiException catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.message);
      return false;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: 'Đổi mật khẩu thất bại');
      return false;
    }
  }

  Future<void> logout() async {
    await _repo.logout();
    state = const AuthState(isInitialized: true);
  }

  void clearError() {
    state = state.copyWith(clearError: true);
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return authRepository;
});

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return AuthNotifier(repo);
});

final currentUserProvider = Provider<UserModel?>((ref) {
  return ref.watch(authProvider).user;
});

final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).isAuthenticated;
});
