import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:fleet_pulse/features/authentication/models/user_model.dart';

part 'auth_state.freezed.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState({
    UserModel? user,
    String? token,
    @Default(false) bool isLoading,
    @Default(false) bool isAuthenticated,
    String? errorMessage,
  }) = _AuthState;
}