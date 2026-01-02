// lib/features/authentication/domain/otp_repository.dart
import '../models/otp.dart';
import '../models/auth_response.dart';

abstract class OtpRepository {
  Future<AuthResponse> verifyOtp(Otp otp);
  Future<void> resendOtp(String phoneNumber);
}
