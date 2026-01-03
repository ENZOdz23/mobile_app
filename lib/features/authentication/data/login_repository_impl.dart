// lib/features/authentication/data/login_repository_impl.dart
import 'datasources/auth_remote_data_source.dart';
import '../domain/login_repository.dart';

class LoginRepositoryImpl implements LoginRepository {
  final IAuthRemoteDataSource remoteDataSource;

  LoginRepositoryImpl({IAuthRemoteDataSource? remoteDataSource})
    : remoteDataSource = remoteDataSource ?? AuthRemoteDataSource();

  @override
  Future<bool> checkPhoneNumberExists(String phoneNumber) async {
    try {
      return await remoteDataSource.checkPhoneNumberExists(phoneNumber);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> requestOtp(String phoneNumber) async {
    try {
      return await remoteDataSource.requestOtp(phoneNumber);
    } catch (e) {
      rethrow;
    }
  }
}
