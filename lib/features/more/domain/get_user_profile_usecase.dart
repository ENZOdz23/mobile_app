import '../data/more_repository.dart';
import '../models/user_profile.dart';

class GetUserProfileUseCase {
  final MoreRepository repository;

  GetUserProfileUseCase(this.repository);

  Future<UserProfile> call() async {
    return await repository.getUserProfile();
  }
}
