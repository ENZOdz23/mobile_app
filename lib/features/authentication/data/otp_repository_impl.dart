// lib/features/authentication/data/otp_repository_impl.dart
import 'package:flutter/foundation.dart';

import '../domain/otp_repository.dart';
import '../models/otp.dart';
import '../../../core/api/api_client.dart';

class OtpRepositoryImpl implements OtpRepository {
  @override
  Future<bool> verifyOtp(Otp otp) async {
    try {
      debugPrint(
        'otp_repository_impl: verifying otp for phone=${otp.phoneNumber}, code=${otp.code}',
      );
      final resp = await Api.verifyOtp(otp.code);
      final status = resp.statusCode ?? 0;
      debugPrint(
        'otp_repository_impl: verifyOtp response status=$status body=${resp.data}',
      );
      return status >= 200 && status < 300;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<void> resendOtp(String phoneNumber) async {
    try {
      debugPrint('otp_repository_impl: resendOtp for phone=$phoneNumber');
      final resp = await Api.resendOtp(phoneNumber);
      final status = resp.statusCode ?? 0;
      debugPrint(
        'otp_repository_impl: resendOtp response status=$status body=${resp.data}',
      );
      if (status < 200 || status >= 300) {
        final body = resp.data?.toString();
        throw Exception(body ?? 'Failed to resend OTP (status $status)');
      }
    } catch (e) {
      debugPrint('otp_repository_impl: resendOtp error: $e');
      rethrow;
    }
  }
}
