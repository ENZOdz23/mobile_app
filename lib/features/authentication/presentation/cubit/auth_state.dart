// lib/features/authentication/presentation/cubit/auth_state.dart

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final String message;

  AuthSuccess(this.message);
}

class AuthError extends AuthState {
  final String message;

  AuthError(this.message);
}

class OtpVerificationSuccess extends AuthState {
  final bool success;

  OtpVerificationSuccess(this.success);
}
