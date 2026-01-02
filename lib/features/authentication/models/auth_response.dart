// lib/features/authentication/models/auth_response.dart

class AuthResponse {
  final String token;
  final String? userId;
  final String phoneNumber;

  AuthResponse({
    required this.token,
    this.userId,
    required this.phoneNumber,
  });
}

