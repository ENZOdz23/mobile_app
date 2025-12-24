import 'package:dio/dio.dart';

class Api {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl:
          //192.168.43.26:8000
          "http://localhost:8000/api", // change this based on the server
      headers: {"Content-Type": "application/json"},
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ),
  );

  /// Get the Dio instance for use in data sources
  static Dio getDio() => _dio;

  ///AUTH HEADERS

  static void setToken(String token) {
    _dio.options.headers['Authorization'] = "Bearer $token";
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
