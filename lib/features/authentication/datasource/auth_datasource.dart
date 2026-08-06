import 'package:dio/dio.dart';
import 'package:fleet_pulse/core/api/api_client.dart';
import 'package:fleet_pulse/features/authentication/models/login_request.dart';
import 'package:fleet_pulse/features/authentication/models/login_response.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthDatasource {
  final ApiClient _apiClient;

  AuthDatasource(this._apiClient);

  Future<LoginResponse> login(LoginRequest request) async {
    try {
      final response = await _apiClient.dio.post(
        '/api/Authentication/login',
        data: request.toJson(),
      );

      if (response.data['isSuccess'] == true) {
        return LoginResponse.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? 'Error en login');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final message = e.response?.data['message'] ?? 'Error de autenticación';
        throw Exception(message);
      } else {
        throw Exception('Error de conexión');
      }
    }
  }
}

final authDatasourceProvider = Provider<AuthDatasource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return AuthDatasource(apiClient);
});