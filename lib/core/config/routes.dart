// lib/core/config/routes.dart

import 'package:flutter/material.dart';
import '../../features/authentication/presentation/login_screen.dart';
import '../../features/authentication/presentation/otp_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/entreprise_state/entreprise_state.dart';
import '../../features/contacts/presentation/contacts_list_screen.dart';
import '../../features/calendar/presentation/calendar_screen.dart';
import '../../features/more/presentation/more_screen.dart';

class AppRoutes {
  static const String login = '/';
  static const String otp = '/otp';
  static const String dashboard = '/dashboard';
  static const String home = '/home';
  static const String changeEntrepriseState = '/change-entreprise-state';
  static const String contacts = '/contacts';
  static const String calendar = '/calendar';
  static const String more = '/more';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case otp:
        final phoneNumber = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => OtpScreen(phoneNumber: phoneNumber),
        );

      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());

      case changeEntrepriseState:
        return MaterialPageRoute(
          builder: (_) => ChangeEntrepriseStatePage(
            getCompaniesUseCase: GetCompaniesUseCase(CompanyRepositoryImpl()),
            getStatesUseCase: GetStatesUseCase(CompanyRepositoryImpl()),
            updateCompanyStateUseCase: UpdateCompanyStateUseCase(CompanyRepositoryImpl()),
          ),
        );

      case contacts:
        return MaterialPageRoute(builder: (_) => ContactsListScreen());

      case calendar:
        return MaterialPageRoute(builder: (_) => CalendarScreen());

      case more:
        return MaterialPageRoute(builder: (_) => const MoreScreen());

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
