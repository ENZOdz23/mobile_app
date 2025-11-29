import '../data/more_repository.dart';
import '../models/network_speed.dart';

class TestNetworkSpeedUseCase {
  final MoreRepository repository;

  TestNetworkSpeedUseCase(this.repository);

  Future<NetworkSpeed> call() async {
    return await repository.testNetworkSpeed();
  }
}
