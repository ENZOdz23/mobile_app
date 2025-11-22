// lib/features/authentication/domain/otp_repository.dart
import '../models/otp.dart';

abstract class OtpRepository {
  Future<bool> verifyOtp(Otp otp);
  Future<void> resendOtp(String phoneNumber);
}
