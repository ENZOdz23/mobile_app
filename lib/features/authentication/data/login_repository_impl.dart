// lib/features/authentication/data/login_repository_impl.dart
import 'package:dio/dio.dart';

import '../domain/login_repository.dart';
import '../../../core/api/api_client.dart';

class LoginRepositoryImpl implements LoginRepository {
  @override
  Future<void> requestOtp(String phoneNumber) async {
    try {
      final resp = await Api.sendOtp(phoneNumber);
      final status = resp.statusCode ?? 0;
      if (status < 200 || status >= 300) {
        // Include full response body when available to aid debugging
        final body = resp.data?.toString();
        final msg = (resp.data is Map && resp.data['message'] != null)
            ? resp.data['message'].toString()
            : (body ?? 'Failed to request OTP (status $status)');
        throw Exception(msg);
      }
    } on DioException catch (err) {
      // Prefer server-provided message when available; otherwise include full body
      final respData = err.response?.data;
      final serverMsg = (respData is Map && respData['message'] != null)
          ? respData['message']?.toString()
          : (respData?.toString());
      throw Exception(
        serverMsg ?? err.message ?? 'Network error while requesting OTP',
      );
    } catch (e) {
      rethrow;
    }
  }
}
