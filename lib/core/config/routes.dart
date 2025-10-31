// lib/core/config/routes.dart

import 'package:flutter/material.dart';
import '../../features/authentication/presentation/login_screen.dart';
import '../../features/authentication/presentation/otp_screen.dart';
import '../../features/dashboard/presentation/dashboard_screen.dart';

class AppRoutes {
  static const String login = '/';
  static const String otp = '/otp';
  static const String dashboard = '/dashboard';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case otp:
        final phoneNumber = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => OtpScreen(phoneNumber: phoneNumber),
        );

      // case dashboard:
      //   return MaterialPageRoute(builder: (_) => const DashboardScreen());

      // Add other routes as needed

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
