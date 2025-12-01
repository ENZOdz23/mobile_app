// lib/features/authentication/domain/login_repository.dart

abstract class LoginRepository {
  Future<void> requestOtp(String phoneNumber);
}
