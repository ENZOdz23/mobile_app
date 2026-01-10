// lib/features/authentication/presentation/screens/auth_test_screen.dart
// Temporary test screen - remove after validation

import 'package:flutter/material.dart';
import '../../data/login_repository_impl.dart';
import '../../data/otp_repository_impl.dart';
import '../../domain/request_otp_usecase.dart';
import '../../domain/verify_otp_usecase.dart';
import '../../domain/resend_otp_usecase.dart';
import '../../models/otp.dart';

class AuthTestScreen extends StatefulWidget {
  const AuthTestScreen({super.key});

  @override
  State<AuthTestScreen> createState() => _AuthTestScreenState();
}

class _AuthTestScreenState extends State<AuthTestScreen> {
  final _phoneController = TextEditingController(text: '0542930649');
  final _otpController = TextEditingController();
  String _log = '';

  late RequestOtpUseCase _requestOtpUseCase;
  late VerifyOtpUseCase _verifyOtpUseCase;
  late ResendOtpUseCase _resendOtpUseCase;

  @override
  void initState() {
    super.initState();
    final loginRepo = LoginRepositoryImpl();
    final otpRepo = OtpRepositoryImpl();
    _requestOtpUseCase = RequestOtpUseCase(loginRepo);
    _verifyOtpUseCase = VerifyOtpUseCase(otpRepo);
    _resendOtpUseCase = ResendOtpUseCase(otpRepo);
  }

  void _addLog(String message) {
    setState(() {
      _log = '${DateTime.now().toIso8601String()}\n$message\n\n$_log';
    });
    debugPrint('[AuthTest] $message');
  }

  Future<void> _testRequestOtp() async {
    _addLog('🔵 Testing Request OTP...');
    try {
      await _requestOtpUseCase(_phoneController.text);
      _addLog('✅ Request OTP Success');
    } catch (e) {
      _addLog('❌ Request OTP Error: $e');
    }
  }

  Future<void> _testVerifyOtp() async {
    _addLog('🔵 Testing Verify OTP...');
    try {
      final otp = Otp(
        code: _otpController.text,
        phoneNumber: _phoneController.text,
      );
      final result = await _verifyOtpUseCase(otp);
      _addLog('✅ Verify OTP Success: $result');
    } catch (e) {
      _addLog('❌ Verify OTP Error: $e');
    }
  }

  Future<void> _testResendOtp() async {
    _addLog('🔵 Testing Resend OTP...');
    try {
      await _resendOtpUseCase(_phoneController.text);
      _addLog('✅ Resend OTP Success');
    } catch (e) {
      _addLog('❌ Resend OTP Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Auth API Test'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Phone Number:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            const Text(
              'OTP Code:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _otpController,
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _testRequestOtp,
              icon: const Icon(Icons.phone),
              label: const Text('Request OTP'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: _testVerifyOtp,
              icon: const Icon(Icons.check),
              label: const Text('Verify OTP'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: _testResendOtp,
              icon: const Icon(Icons.refresh),
              label: const Text('Resend OTP'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
            const SizedBox(height: 24),
            const Divider(),
            const Text(
              'Test Log:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
            const SizedBox(height: 8),
            Container(
              height: 300,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[100],
              ),
              child: SingleChildScrollView(
                child: Text(
                  _log.isEmpty ? 'No logs yet...' : _log,
                  style: const TextStyle(fontFamily: 'monospace', fontSize: 10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }
}
