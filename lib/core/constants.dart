/// Core application constants
/// 
/// This file contains shared constants used throughout the application
/// such as API endpoints, app configuration values, etc.
/// 
/// Note: Move sensitive or environment-specific values to a separate
/// config file (lib/core/config/) for better security and flexibility.

class AppConstants {
  // Prevent instantiation
  AppConstants._();

  // API Configuration
  // TODO: Move to environment config (lib/core/config/environment.dart)
  static const String apiBaseUrl = 'https://api.example.com'; // Replace with actual URL
  static const int apiTimeout = 30000; // milliseconds

  // App Configuration
  static const String appName = 'CRM Sales Performance Mobilis';
  static const String appVersion = '1.0.0';

  // Add your constants here
}
