// lib/features/authentication/data/login_repository_impl.dart
import 'datasources/auth_remote_data_source.dart';
import '../domain/login_repository.dart';

class LoginRepositoryImpl implements LoginRepository {
  final IAuthRemoteDataSource remoteDataSource;

  LoginRepositoryImpl({IAuthRemoteDataSource? remoteDataSource})
    : remoteDataSource = remoteDataSource ?? AuthRemoteDataSource();

  @override
  Future<void> requestOtp(String phoneNumber) async {
    try {
      await remoteDataSource.requestOtp(phoneNumber);
    } catch (e) {
      throw Exception('Repository: Failed to request OTP - $e');
    }
  }
}
