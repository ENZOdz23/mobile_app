import 'dart:async';
import 'package:flutter_internet_speed_test/flutter_internet_speed_test.dart';
import '../models/user_profile.dart';
import '../models/network_speed.dart';

/// Repository for More screen data operations
/// Handles user profile and network speed testing using flutter_internet_speed_test
class MoreRepository {
  final FlutterInternetSpeedTest _speedTest = FlutterInternetSpeedTest();
  StreamController<NetworkSpeed>? _speedTestController;
  bool _isTestRunning = false;

  /// Convert Unit enum to string representation
  String _unitToString(dynamic unit) {
    final unitStr = unit.toString();
    if (unitStr.contains('Mbps')) return 'Mbps';
    if (unitStr.contains('Kbps')) return 'Kbps';
    if (unitStr.contains('Gbps')) return 'Gbps';
    return 'Mbps'; // Default
  }

  // Fetch user profile
  Future<UserProfile> getUserProfile() async {
    await Future.delayed(const Duration(seconds: 1));
    return UserProfile(
      name: 'M. alaeddine AID',
      role: 'Commercial',
      email: 'asma.aid@prospectra.dz',
      phoneNumber: '+213 661 208 668',
      initials: 'AA',
    );
  }

  /// Start network speed test using flutter_internet_speed_test
  /// Returns a stream of NetworkSpeed updates for progress tracking
  Stream<NetworkSpeed> testNetworkSpeed() {
    if (_isTestRunning) {
      throw Exception('A speed test is already in progress');
    }

    _speedTestController = StreamController<NetworkSpeed>.broadcast();
    _isTestRunning = true;

    NetworkSpeed currentSpeed = NetworkSpeed(isLoading: true);

    _speedTest.startTesting(
      useFastApi: true, // Use Fast.com API for faster results
      onStarted: () {
        // Test started
        currentSpeed = currentSpeed.copyWith(
          isLoading: true,
          progressPercent: 0,
          isDownloadComplete: false,
          isUploadComplete: false,
        );
        _speedTestController?.add(currentSpeed);
      },
      onCompleted: (TestResult download, TestResult upload) {
        // Test completed
        final completedSpeed = NetworkSpeed(
          downloadSpeed: download.transferRate,
          uploadSpeed: upload.transferRate,
          downloadUnit: _unitToString(download.unit),
          uploadUnit: _unitToString(upload.unit),
          isLoading: false,
          progressPercent: 100,
          isDownloadComplete: true,
          isUploadComplete: true,
        );
        _speedTestController?.add(completedSpeed);
        _speedTestController?.close();
        _isTestRunning = false;
      },
      onProgress: (percent, data) {
        // Progress update during test
        bool isDownload = !currentSpeed.isDownloadComplete;

        if (isDownload) {
          // Download in progress
          currentSpeed = currentSpeed.copyWith(
            downloadSpeed: data.transferRate,
            downloadUnit: _unitToString(data.unit),
            progressPercent: percent.round(),
            isLoading: true,
          );
        } else {
          // Upload in progress
          currentSpeed = currentSpeed.copyWith(
            uploadSpeed: data.transferRate,
            uploadUnit: _unitToString(data.unit),
            progressPercent: percent.round(),
            isLoading: true,
          );
        }
        _speedTestController?.add(currentSpeed);
      },
      onError: (String errorMessage, String speedTestError) {
        // Error occurred
        _speedTestController?.addError(
          Exception('Speed test error: $errorMessage - $speedTestError'),
        );
        _speedTestController?.close();
        _isTestRunning = false;
      },
      onDefaultServerSelectionDone: (Client? client) {
        // Server selected, starting test
        if (client != null) {
          // Server selected successfully
        }
      },
      onDefaultServerSelectionInProgress: () {
        // Selecting server
        currentSpeed = currentSpeed.copyWith(
          isLoading: true,
          progressPercent: 0,
        );
        _speedTestController?.add(currentSpeed);
      },
      onDownloadComplete: (TestResult data) {
        // Download phase completed
        currentSpeed = currentSpeed.copyWith(
          downloadSpeed: data.transferRate,
          downloadUnit: _unitToString(data.unit),
          isDownloadComplete: true,
          progressPercent: 50, // Halfway through (download done, upload starting)
        );
        _speedTestController?.add(currentSpeed);
      },
      onUploadComplete: (TestResult data) {
        // Upload phase completed
        currentSpeed = currentSpeed.copyWith(
          uploadSpeed: data.transferRate,
          uploadUnit: _unitToString(data.unit),
          isUploadComplete: true,
          progressPercent: 100,
        );
        _speedTestController?.add(currentSpeed);
      },
      onCancel: () {
        // Test cancelled
        _speedTestController?.add(
          NetworkSpeed(isLoading: false),
        );
        _speedTestController?.close();
        _isTestRunning = false;
      },
    );

    return _speedTestController!.stream;
  }

  /// Cancel ongoing speed test
  void cancelSpeedTest() {
    if (_isTestRunning && _speedTestController != null) {
      _speedTestController?.close();
      _isTestRunning = false;
    }
  }

  /// Dispose resources
  void dispose() {
    cancelSpeedTest();
  }

  // Update user profile
  Future<void> updateUserProfile(UserProfile profile) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // Save to local storage or API
  }
}
