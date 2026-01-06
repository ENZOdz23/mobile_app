import 'package:dio/dio.dart';
import '../storage/local_storage_service.dart';
import '../../core/config/routes.dart';
import 'package:flutter/material.dart';

// Global navigator key for navigation from interceptors
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class Api {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl:
          //192.168.43.26:8000
          "https://mobile-app-server-1-vgc2.onrender.com/api/", // change this based on the server
      headers: {"Content-Type": "application/json"},
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ),
  );

  static bool _initialized = false;
  static bool _initializing = false;

  /// Initialize API client with interceptors
  static Future<void> initialize() async {
    if (_initialized || _initializing) return;
    _initializing = true;

    // Add request interceptor to include token
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Get token from storage
          final storage = await LocalStorageService.getInstance();
          final token = storage.getAuthToken();
          
          if (token != null) {
            // Use "Token <token>" format as per requirements
            options.headers['Authorization'] = 'Token $token';
          }
          
          return handler.next(options);
        },
        onError: (error, handler) async {
          // Handle 401 Unauthorized
          if (error.response?.statusCode == 401) {
            final storage = await LocalStorageService.getInstance();
            await storage.clearAllAuthData();
            clearToken();
            
            // Navigate to login
            if (navigatorKey.currentContext != null) {
              Navigator.of(navigatorKey.currentContext!).pushNamedAndRemoveUntil(
                AppRoutes.login,
                (route) => false,
              );
            }
            
            return handler.reject(
              DioException(
                requestOptions: error.requestOptions,
                response: error.response,
                type: DioExceptionType.badResponse,
                error: 'Unauthorized. Please login again.',
              ),
            );
          }
          
          // Handle 403 Forbidden
          if (error.response?.statusCode == 403) {
            // Show error message
            if (navigatorKey.currentContext != null) {
              ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
                const SnackBar(
                  content: Text('Access forbidden. You do not have permission to perform this action.'),
                  backgroundColor: Colors.red,
                ),
              );
            }
            
            return handler.reject(
              DioException(
                requestOptions: error.requestOptions,
                response: error.response,
                type: DioExceptionType.badResponse,
                error: 'Forbidden. You do not have permission.',
              ),
            );
          }
          
          return handler.next(error);
        },
      ),
    );

    // Load token on initialization
    final storage = await LocalStorageService.getInstance();
    final token = storage.getAuthToken();
    if (token != null) {
      _dio.options.headers['Authorization'] = 'Token $token';
    }

    _initialized = true;
    _initializing = false;
  }

  /// Get the Dio instance for use in data sources
  static Dio getDio() {
    return _dio;
  }

  ///AUTH HEADERS

  static void setToken(String token) {
    _dio.options.headers['Authorization'] = "Token $token";
  }

  static void clearToken() {
    _dio.options.headers.remove('Authorization');
  }

  ///AUTH APIs

  static Future<Response> login({
    required String email,
    required String password,
  }) {
    return _dio.post(
      "/auth/login",
      data: {"email": email, "password": password},
    );
  }

  static Future<Response> register({
    required String email,
    required String password,
    required String name,
  }) {
    return _dio.post(
      "/auth/register",
      data: {"email": email, "password": password, "name": name},
    );
  }

  /// ===== OTP APIs =====

  static Future<Response> sendOtp(String phone) {
    // Send as form-url-encoded so Django views that read request.POST can access the field
    return _dio.post(
      "/auth/request-otp/",
      // Backend expects `phone_number` per API spec (not `phone`).
      data: {"phone_number": phone},
      options: Options(contentType: Headers.formUrlEncodedContentType),
    );
  }

  static Future<Response> verifyOtp(String otp) {
    // Ensure trailing slash so Django routing with APPEND_SLASH works and POST bodies are preserved.
    return _dio.post("/auth/verify-otp/", data: {"otp": otp});
  }

  static Future<Response> resendOtp(String phone) {
    // Use same field name and content type as request-otp to match server expectations.
    return _dio.post(
      "/auth/resend-otp/",
      data: {"phone_number": phone},
      options: Options(contentType: Headers.formUrlEncodedContentType),
    );
  }

  /// ===== Example GET API =====
  static Future<Response> getUserProfile() {
    return _dio.get("/user/profile");
  }
}
