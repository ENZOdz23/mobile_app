// lib/features/authentication/domain/verify_otp_usecase.dart
import 'otp_repository.dart';
import '../models/otp.dart';

class VerifyOtpUseCase {
  final OtpRepository repository;

  VerifyOtpUseCase(this.repository);

  Future<bool> call(Otp otp) async {
    return await repository.verifyOtp(otp);
  }
}
