import 'dart:async';
import 'package:flutter/material.dart';
import '../api/api_client.dart';

class MotivationManager {
  static Timer? _timer;

  static void start() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(minutes: 5), (timer) {
      _showMotivationDialog();
    });
  }

  static void stop() {
    _timer?.cancel();
    _timer = null;
  }

  static void _showMotivationDialog() {
    final context = navigatorKey.currentContext;
    if (context != null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Motivation 🚀'),
          content: const Text('Stay Motivated!'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }
}
