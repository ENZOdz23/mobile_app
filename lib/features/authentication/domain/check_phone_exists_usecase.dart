// lib/features/authentication/domain/check_phone_exists_usecase.dart

import 'login_repository.dart';

class CheckPhoneExistsUseCase {
  final LoginRepository repository;

  CheckPhoneExistsUseCase(this.repository);

  Future<bool> call(String phoneNumber) async {
    return await repository.checkPhoneNumberExists(phoneNumber);
  }
}
