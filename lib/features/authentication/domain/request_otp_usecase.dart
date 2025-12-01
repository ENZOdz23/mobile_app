// lib/features/authentication/domain/request_otp_usecase.dart

import 'login_repository.dart';

class RequestOtpUseCase {
  final LoginRepository repository;

  RequestOtpUseCase(this.repository);

  Future<void> call(String phoneNumber) async {
    await repository.requestOtp(phoneNumber);
  }
}
