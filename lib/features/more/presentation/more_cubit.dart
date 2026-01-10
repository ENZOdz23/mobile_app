import 'dart:async';
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
  final NetworkSpeed networkSpeed;

  NetworkSpeedTesting({
    required this.userProfile,
    required this.networkSpeed,
  });
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
  StreamSubscription<NetworkSpeed>? _speedTestSubscription;

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

  /// Start network speed test and listen to stream updates
  void testNetworkSpeed() {
    if (_currentProfile == null) {
      emit(MoreError('User profile not loaded'));
      return;
    }

    // Cancel any existing test
    _speedTestSubscription?.cancel();

    try {
      // Start the test and listen to updates
      final speedStream = testNetworkSpeedUseCase.execute();

      _speedTestSubscription = speedStream.listen(
        (speed) {
          _networkSpeed = speed;

          if (speed.isLoading) {
            // Test in progress
            emit(NetworkSpeedTesting(
              userProfile: _currentProfile!,
              networkSpeed: speed,
            ));
          } else {
            // Test completed
            emit(NetworkSpeedTested(
              userProfile: _currentProfile!,
              networkSpeed: speed,
            ));
          }
        },
        onError: (error) {
          emit(MoreError(
            'Failed to test network speed: ${error.toString()}',
          ));
          // Reset to loaded state with previous speed
          if (_currentProfile != null) {
            emit(MoreLoaded(
              userProfile: _currentProfile!,
              networkSpeed: _networkSpeed,
            ));
          }
        },
        onDone: () {
          // Stream completed - ensure final state is emitted
          if (_currentProfile != null && !_networkSpeed.isLoading) {
            emit(NetworkSpeedTested(
              userProfile: _currentProfile!,
              networkSpeed: _networkSpeed,
            ));
          }
        },
      );
    } catch (e) {
      emit(MoreError('Failed to start network speed test: ${e.toString()}'));
    }
  }

  /// Cancel ongoing speed test
  void cancelSpeedTest() {
    _speedTestSubscription?.cancel();
    testNetworkSpeedUseCase.cancel();

    if (_currentProfile != null) {
      _networkSpeed = _networkSpeed.copyWith(isLoading: false);
      emit(MoreLoaded(
        userProfile: _currentProfile!,
        networkSpeed: _networkSpeed,
      ));
    }
  }

  @override
  Future<void> close() {
    _speedTestSubscription?.cancel();
    testNetworkSpeedUseCase.dispose();
    return super.close();
  }
}
