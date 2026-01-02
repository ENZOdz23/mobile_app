// lib/features/authentication/data/otp_repository_impl.dart
import 'datasources/auth_remote_data_source.dart';
import '../domain/otp_repository.dart';
import '../models/otp.dart';
import '../models/auth_response.dart';

class OtpRepositoryImpl implements OtpRepository {
  final IAuthRemoteDataSource remoteDataSource;

  OtpRepositoryImpl({IAuthRemoteDataSource? remoteDataSource})
    : remoteDataSource = remoteDataSource ?? AuthRemoteDataSource();

  @override
  Future<AuthResponse> verifyOtp(Otp otp) async {
    try {
      return await remoteDataSource.verifyOtp(otp.phoneNumber, otp.code);
    } catch (e) {
      throw Exception('Repository: Failed to verify OTP - $e');
    }
  }

  @override
  Future<void> resendOtp(String phoneNumber) async {
    try {
      await remoteDataSource.resendOtp(phoneNumber);
    } catch (e) {
      throw Exception('Repository: Failed to resend OTP - $e');
    }
  }
}
