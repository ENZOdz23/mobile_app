// lib/features/authentication/data/datasources/auth_remote_data_source.dart

import 'package:dio/dio.dart';
import '../../../../core/api/api_client.dart';

import '../../models/auth_response.dart';

abstract class IAuthRemoteDataSource {
  Future<bool> checkPhoneNumberExists(String phoneNumber);
  Future<String> requestOtp(String phoneNumber);
  Future<AuthResponse> verifyOtp(String phoneNumber, String otpCode);
  Future<String> resendOtp(String phoneNumber);
}

class AuthRemoteDataSource implements IAuthRemoteDataSource {
  final Dio _dio;

  AuthRemoteDataSource({Dio? dio}) : _dio = dio ?? Api.getDio();

  /// Safely extract user ID from response data (handles both String and int)
  String? _extractUserId(Map<String, dynamic> data) {
    try {
      // Try user_id first
      final userId = data['user_id'];
      if (userId != null) {
        return userId.toString();
      }

      // Try user (could be an object or ID)
      final user = data['user'];
      if (user != null) {
        if (user is Map) {
          // If user is an object, try to get id from it
          final userIdFromObject = user['id'];
          if (userIdFromObject != null) {
            return userIdFromObject.toString();
          }
        } else {
          return user.toString();
        }
      }

      // Try id
      final id = data['id'];
      if (id != null) {
        return id.toString();
      }

      return null;
    } catch (e) {
      // If extraction fails, return null (userId is optional)
      return null;
    }
  }

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
      final errorMsg = _extractErrorMessage(e);
      throw Exception('Failed to check phone number: $errorMsg');
    } catch (e) {
      throw Exception('Failed to check phone number: $e');
    }
  }

  @override
  Future<String> requestOtp(String phoneNumber) async {
    try {
      // Generate OTP
      final response = await _dio.post(
        '/otps/generate/',
        data: {'phone_number': phoneNumber},
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Failed to request OTP: ${response.statusCode}');
      }

      // Extract OTP code from response
      final data = response.data;
      if (data is Map<String, dynamic> && data.containsKey('otp_code')) {
        return data['otp_code'].toString();
      }
      throw Exception('OTP code not found in response');
    } on DioException catch (e) {
      final errorMsg = _extractErrorMessage(e);
      throw Exception('Failed to request OTP: $errorMsg');
    } catch (e) {
      throw Exception('Failed to request OTP: $e');
    }
  }

  /// Safely extract error message from DioException
  String _extractErrorMessage(DioException e) {
    try {
      final responseData = e.response?.data;

      // If responseData is a Map, try to extract error message
      if (responseData is Map) {
        try {
          // Try to cast to Map<String, dynamic> safely
          final dataMap = Map<String, dynamic>.from(responseData);

          // Try 'error' field first
          final error = dataMap['error'];
          if (error != null) {
            // Handle different error formats
            if (error is String) {
              return error;
            } else if (error is Map) {
              // Try common error message fields in nested error
              return error['message']?.toString() ??
                  error['detail']?.toString() ??
                  error['error']?.toString() ??
                  error.toString();
            } else if (error is List) {
              // Handle list of errors
              return error.join(', ');
            } else {
              return error.toString();
            }
          }

          // Try other common error fields
          final message = dataMap['message'];
          if (message != null) {
            return message.toString();
          }

          final detail = dataMap['detail'];
          if (detail != null) {
            return detail.toString();
          }

          // Try 'non_field_errors' (Django REST framework style)
          final nonFieldErrors = dataMap['non_field_errors'];
          if (nonFieldErrors != null) {
            if (nonFieldErrors is List) {
              return nonFieldErrors.join(', ');
            }
            return nonFieldErrors.toString();
          }

          // If map has values, try to extract first meaningful message
          if (dataMap.isNotEmpty) {
            return dataMap.values.first.toString();
          }
        } catch (mapError) {
          // If map parsing fails, just convert to string
          return responseData.toString();
        }
      } else if (responseData is String) {
        // If responseData is a String, use it directly
        return responseData;
      }

      // Fallback to DioException message or status code
      if (e.response?.statusCode != null) {
        return e.message ?? 'HTTP ${e.response!.statusCode}';
      }

      return e.message ?? 'Unknown error occurred';
    } catch (parseError) {
      // If anything fails, return a safe error message
      return e.message ?? 'Failed to process error response';
    }
  }

  @override
  Future<AuthResponse> verifyOtp(String phoneNumber, String otpCode) async {
    try {
      final response = await _dio.post(
        '/otps/verify/',
        data: {'otp_code': otpCode, 'phone_number': phoneNumber},
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      // Backend returns 200 OK on successful verification with token
      final statusCode = response.statusCode;
      if (statusCode != null && (statusCode == 200 || statusCode == 201)) {
        // Extract token and user info from response
        final responseData = response.data;

        // Handle both Map and String responses
        if (responseData is Map) {
          try {
            // Safely convert to Map<String, dynamic>
            final dataMap = Map<String, dynamic>.from(responseData);

            // Token should be in response.data['token'] or response.data['auth_token']
            final token =
                dataMap['token']?.toString() ??
                dataMap['auth_token']?.toString() ??
                dataMap['access_token']?.toString();

            if (token == null || token.isEmpty) {
              throw Exception(
                'Token not found in response. Response: ${responseData.toString()}',
              );
            }

            // Store token in API client
            Api.setToken(token);

            // Extract user info if available
            final userId = _extractUserId(dataMap);

            return AuthResponse(
              token: token,
              userId: userId,
              phoneNumber: phoneNumber,
            );
          } catch (mapError) {
            throw Exception(
              'Failed to parse response: $mapError. Response: ${responseData.toString()}',
            );
          }
        } else {
          throw Exception(
            'Invalid response format: expected Map but got ${responseData.runtimeType}. Response: ${responseData.toString()}',
          );
        }
      } else {
        final errorMsg = statusCode != null
            ? 'HTTP $statusCode'
            : 'Unknown status code';
        throw Exception('Failed to verify OTP: $errorMsg');
      }
    } on DioException catch (e) {
      // Handle DioException separately
      final errorMsg = _extractErrorMessage(e);
      throw Exception('Remote: Failed to verify OTP - $errorMsg');
    } catch (e) {
      // Handle any other exceptions
      throw Exception('Remote: Failed to verify OTP - ${e.toString()}');
    }
  }

  @override
  Future<String> resendOtp(String phoneNumber) async {
    try {
      // Resend OTP using the /otps/generate/ endpoint (creates new OTP)
      final response = await _dio.post(
        '/otps/generate/',
        data: {'phone_number': phoneNumber},
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Failed to resend OTP: ${response.statusCode}');
      }

      // Extract OTP code from response
      final data = response.data;
      if (data is Map<String, dynamic> && data.containsKey('otp_code')) {
        return data['otp_code'].toString();
      }
      throw Exception('OTP code not found in response');
    } on DioException catch (e) {
      final errorMsg = _extractErrorMessage(e);
      throw Exception('Remote: Failed to resend OTP - $errorMsg');
    } catch (e) {
      throw Exception('Remote: Failed to resend OTP - $e');
    }
  }
}
