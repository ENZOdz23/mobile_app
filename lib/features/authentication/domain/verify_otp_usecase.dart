// lib/features/authentication/domain/verify_otp_usecase.dart
import 'otp_repository.dart';
import '../models/otp.dart';
import '../models/auth_response.dart';

class VerifyOtpUseCase {
  final OtpRepository repository;

  VerifyOtpUseCase(this.repository);

  Future<AuthResponse> call(Otp otp) async {
    return await repository.verifyOtp(otp);
  }
}
