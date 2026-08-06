import 'dart:convert';
import 'package:fleet_pulse/core/api/api_client.dart';
import 'package:fleet_pulse/core/storage/secure_storage.dart';
import 'package:fleet_pulse/core/utils/result.dart';
import 'package:fleet_pulse/features/authentication/models/user_model.dart';
import 'package:fleet_pulse/features/authentication/providers/auth_state.dart';
import 'package:fleet_pulse/features/authentication/repositories/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repository;
  final SecureStorage _storage;
  final ApiClient _apiClient;

  AuthNotifier(this._repository, this._storage, this._apiClient)
      : super(const AuthState());

  Future<void> init() async {
    await _storage.init();
    final token = _storage.getToken();
    final userDataJson = _storage.getUserData();

    if (token != null && userDataJson != null) {
      try {
        final userData = jsonDecode(userDataJson);
        final user = UserModel.fromJson(userData);
        _apiClient.setAuthToken(token);

        state = state.copyWith(
          user: user,
          token: token,
          isAuthenticated: true,
        );
      } catch (e) {
        await logout();
      }
    }
  }

  Future<bool> login(String email, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    final result = await _repository.login(email, password);

    if (result.isSuccess) {
      final response = result.dataOrNull!;

      await _storage.saveToken(response.token);
      await _storage.saveUserData(jsonEncode(response.user.toJson()));

      _apiClient.setAuthToken(response.token);

      state = state.copyWith(
        user: response.user,
        token: response.token,
        isAuthenticated: true,
        isLoading: false,
      );

      return true;
    } else {
      state = state.copyWith(
        isLoading: false,
        errorMessage: result.errorOrNull ?? 'Error en login',
      );
      return false;
    }
  }

  Future<void> logout() async {
    await _storage.clearAll();
    _apiClient.removeAuthToken();

    state = const AuthState();
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  final storage = ref.watch(secureStorageProvider);
  final apiClient = ref.watch(apiClientProvider);

  return AuthNotifier(repository, storage, apiClient);
});