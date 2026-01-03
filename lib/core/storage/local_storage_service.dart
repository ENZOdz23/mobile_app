// lib/core/storage/local_storage_service.dart

import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const String _keyAuthToken = 'auth_token';
  static const String _keyUserId = 'user_id';
  static const String _keyUserPhone = 'user_phone';
  static const String _keyIsLoggedIn = 'is_logged_in';

  static LocalStorageService? _instance;
  static SharedPreferences? _prefs;

  LocalStorageService._internal();

  static Future<LocalStorageService> getInstance() async {
    _instance ??= LocalStorageService._internal();
    _prefs ??= await SharedPreferences.getInstance();
    return _instance!;
  }

  // Auth Token
  Future<void> saveAuthToken(String token) async {
    await _prefs?.setString(_keyAuthToken, token);
  }

  String? getAuthToken() {
    return _prefs?.getString(_keyAuthToken);
  }

  Future<void> clearAuthToken() async {
    await _prefs?.remove(_keyAuthToken);
  }

  // User ID
  Future<void> saveUserId(String userId) async {
    await _prefs?.setString(_keyUserId, userId);
  }

  String? getUserId() {
    return _prefs?.getString(_keyUserId);
  }

  Future<void> clearUserId() async {
    await _prefs?.remove(_keyUserId);
  }

  // User Phone
  Future<void> saveUserPhone(String phone) async {
    await _prefs?.setString(_keyUserPhone, phone);
  }

  String? getUserPhone() {
    return _prefs?.getString(_keyUserPhone);
  }

  Future<void> clearUserPhone() async {
    await _prefs?.remove(_keyUserPhone);
  }

  // Is Logged In
  Future<void> setLoggedIn(bool isLoggedIn) async {
    await _prefs?.setBool(_keyIsLoggedIn, isLoggedIn);
  }

  bool isLoggedIn() {
    return _prefs?.getBool(_keyIsLoggedIn) ?? false;
  }

  // Clear all auth data
  Future<void> clearAllAuthData() async {
    await clearAuthToken();
    await clearUserId();
    await clearUserPhone();
    await setLoggedIn(false);
  }
}

