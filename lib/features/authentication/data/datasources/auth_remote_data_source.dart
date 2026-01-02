// lib/features/authentication/data/datasources/auth_remote_data_source.dart

import 'package:dio/dio.dart';
import '../../../../core/api/api_client.dart';

abstract class IAuthRemoteDataSource {
  Future<bool> checkPhoneNumberExists(String phoneNumber);
  Future<void> requestOtp(String phoneNumber);
  Future<bool> verifyOtp(String phoneNumber, String otpCode);
  Future<void> resendOtp(String phoneNumber);
}

class AuthRemoteDataSource implements IAuthRemoteDataSource {
  final Dio _dio;

  AuthRemoteDataSource({Dio? dio}) : _dio = dio ?? Api.getDio();

  @override
  Future<bool> checkPhoneNumberExists(String phoneNumber) async {
    try {
      // Check if phone number exists in the database
      final response = await _dio.get(
        '/phone-numbers/',
        queryParameters: {'phone_number': phoneNumber},
      );

      // If status is 200/201, phone number exists
      return response.statusCode == 200 || response.statusCode == 201;
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;

      // 404 means phone number doesn't exist
      if (statusCode == 404) {
        return false;
      }

      // Re-throw other errors (400, 500, network errors, etc.)
      final errorMsg = e.response?.data?['error'] ?? e.message;
      throw Exception('Failed to check phone number: $errorMsg');
    } catch (e) {
      throw Exception('Failed to check phone number: $e');
    }
  }

  @override
  Future<void> requestOtp(String phoneNumber) async {
    try {
      // Generate OTP
      final response = await _dio.post(
        '/otps/generate/',
        data: {'phone_number': phoneNumber},
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Failed to request OTP: ${response.statusCode}');
      }
    } on DioException catch (e) {
      final errorMsg = e.response?.data?['error'] ?? e.message;
      throw Exception('Failed to request OTP: $errorMsg');
    } catch (e) {
      throw Exception('Failed to request OTP: $e');
    }
  }

  @override
  Future<bool> verifyOtp(String phoneNumber, String otpCode) async {
    try {
      final response = await _dio.post(
        '/otps/verify/',
        data: {'phone_number': phoneNumber, 'otp_code': otpCode},
      );

      // Backend returns 200 OK on successful verification
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to verify OTP: ${response.statusCode}');
      }
    } on DioException catch (e) {
      final errorMsg = e.response?.data?['error'] ?? e.message;
      throw Exception('Remote: Failed to verify OTP - $errorMsg');
    } catch (e) {
      throw Exception('Remote: Failed to verify OTP - $e');
    }
  }

  @override
  Future<void> resendOtp(String phoneNumber) async {
    try {
      // Resend OTP using the /otps/generate/ endpoint (creates new OTP)
      final response = await _dio.post(
        '/otps/',
        data: {'phone_number': phoneNumber},
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Failed to resend OTP: ${response.statusCode}');
      }
    } on DioException catch (e) {
      final errorMsg = e.response?.data?['error'] ?? e.message;
      throw Exception('Remote: Failed to resend OTP - $errorMsg');
    } catch (e) {
      throw Exception('Remote: Failed to resend OTP - $e');
    }
  }
}
