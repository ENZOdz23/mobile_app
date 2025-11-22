// lib/features/authentication/domain/resend_otp_usecase.dart
import 'otp_repository.dart';

class ResendOtpUseCase {
  final OtpRepository repository;

  ResendOtpUseCase(this.repository);

  Future<void> call(String phoneNumber) async {
    return await repository.resendOtp(phoneNumber);
  }
}
