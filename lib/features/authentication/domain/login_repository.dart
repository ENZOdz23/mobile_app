// lib/features/authentication/domain/login_repository.dart

abstract class LoginRepository {
  Future<bool> checkPhoneNumberExists(String phoneNumber);
  Future<void> requestOtp(String phoneNumber);
}
