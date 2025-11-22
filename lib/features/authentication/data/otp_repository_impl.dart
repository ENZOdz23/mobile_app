// lib/features/authentication/data/otp_repository_impl.dart
import '../domain/otp_repository.dart';
import '../models/otp.dart';

class OtpRepositoryImpl implements OtpRepository {
  @override
  Future<bool> verifyOtp(Otp otp) async {
    // TODO: Replace with real API call
    await Future.delayed(const Duration(seconds: 2));
    return otp.code == "12345"; // Simulated response
  }

  @override
  Future<void> resendOtp(String phoneNumber) async {
    // TODO: Replace with real API call
    await Future.delayed(const Duration(seconds: 1));
  }
}
