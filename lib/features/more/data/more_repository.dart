import 'dart:math';
import '../models/user_profile.dart';
import '../models/network_speed.dart';

class MoreRepository {
  // Simulate fetching user profile
  Future<UserProfile> getUserProfile() async {
    await Future.delayed(const Duration(seconds: 1));
    return UserProfile(
      name: 'Mme. Asma AID',
      role: 'Commercial',
      email: 'asma.aid@prospectra.dz',
      phoneNumber: '+213 661 208 668',
      initials: 'AA',
    );
  }

  // Simulate network speed test
  Future<NetworkSpeed> testNetworkSpeed() async {
    await Future.delayed(const Duration(seconds: 2));
    
    // Simulate random speeds
    final random = Random();
    final downloadSpeed = 500 + random.nextDouble() * 500; // 500-1000 Kbps
    final uploadSpeed = 300 + random.nextDouble() * 300; // 300-600 Kbps
    
    return NetworkSpeed(
      downloadSpeed: downloadSpeed,
      uploadSpeed: uploadSpeed,
      isLoading: false,
    );
  }

  // Update user profile
  Future<void> updateUserProfile(UserProfile profile) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // Save to local storage or API
  }
}
