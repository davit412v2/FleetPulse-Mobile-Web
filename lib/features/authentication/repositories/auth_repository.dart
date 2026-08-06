import 'package:fleet_pulse/core/utils/result.dart';
import 'package:fleet_pulse/features/authentication/datasource/auth_datasource.dart';
import 'package:fleet_pulse/features/authentication/models/login_request.dart';
import 'package:fleet_pulse/features/authentication/models/login_response.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthRepository {
  final AuthDatasource _datasource;

  AuthRepository(this._datasource);

  Future<Result<LoginResponse>> login(String email, String password) async {
    try {
      final request = LoginRequest(email: email, password: password);
      final response = await _datasource.login(request);
      return Success(response);
    } catch (e) {
      return Failure(e.toString());
    }
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final datasource = ref.watch(authDatasourceProvider);
  return AuthRepository(datasource);
});