import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/user_profile.dart';
import '../models/network_speed.dart';
import '../domain/get_user_profile_usecase.dart';
import '../domain/test_network_speed_usecase.dart';

// States
abstract class MoreState {}

class MoreInitial extends MoreState {}

class MoreLoading extends MoreState {}

class MoreLoaded extends MoreState {
  final UserProfile userProfile;
  final NetworkSpeed networkSpeed;

  MoreLoaded({
    required this.userProfile,
    required this.networkSpeed,
  });
}

class MoreError extends MoreState {
  final String message;
  MoreError(this.message);
}

class NetworkSpeedTesting extends MoreState {
  final UserProfile userProfile;
  NetworkSpeedTesting(this.userProfile);
}

class NetworkSpeedTested extends MoreState {
  final UserProfile userProfile;
  final NetworkSpeed networkSpeed;

  NetworkSpeedTested({
    required this.userProfile,
    required this.networkSpeed,
  });
}

// Cubit
class MoreCubit extends Cubit<MoreState> {
  final GetUserProfileUseCase getUserProfileUseCase;
  final TestNetworkSpeedUseCase testNetworkSpeedUseCase;

  UserProfile? _currentProfile;
  NetworkSpeed _networkSpeed = NetworkSpeed();

  MoreCubit({
    required this.getUserProfileUseCase,
    required this.testNetworkSpeedUseCase,
  }) : super(MoreInitial());

  Future<void> loadUserProfile() async {
    try {
      emit(MoreLoading());
      final profile = await getUserProfileUseCase();
      _currentProfile = profile;
      emit(MoreLoaded(
        userProfile: profile,
        networkSpeed: _networkSpeed,
      ));
    } catch (e) {
      emit(MoreError('Failed to load user profile: ${e.toString()}'));
    }
  }

  Future<void> testNetworkSpeed() async {
    if (_currentProfile == null) return;

    try {
      emit(NetworkSpeedTesting(_currentProfile!));
      final speed = await testNetworkSpeedUseCase();
      _networkSpeed = speed;
      emit(NetworkSpeedTested(
        userProfile: _currentProfile!,
        networkSpeed: speed,
      ));
    } catch (e) {
      emit(MoreError('Failed to test network speed: ${e.toString()}'));
    }
  }
}
