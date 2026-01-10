import 'dart:async';
import '../data/more_repository.dart';
import '../models/network_speed.dart';

/// Use case for testing network speed
/// Returns a stream of NetworkSpeed updates for real-time progress tracking
class TestNetworkSpeedUseCase {
  final MoreRepository repository;

  TestNetworkSpeedUseCase(this.repository);

  /// Start network speed test and return a stream of updates
  Stream<NetworkSpeed> execute() {
    return repository.testNetworkSpeed();
  }

  /// Cancel ongoing speed test
  void cancel() {
    repository.cancelSpeedTest();
  }

  /// Dispose resources
  void dispose() {
    repository.dispose();
  }
}
