// lib/core/config/routes.dart

import 'package:flutter/material.dart';
import '../../features/authentication/presentation/login_screen.dart';
import '../../features/authentication/presentation/otp_screen.dart';
import '../../features/authentication/presentation/screens/auth_test_screen.dart';
import '../../features/offres/presentation/home_screen.dart';
import '../../features/entreprise_state/entreprise_state.dart';
import '../../features/contacts/presentation/contacts_list_screen.dart';
import '../../features/calendar/presentation/calendar_screen.dart';
import '../../features/more/presentation/more_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/more/presentation/screens/wallet_screen.dart';
import '../../features/more/presentation/screens/language_screen.dart';
import '../../features/more/presentation/screens/privacy_screen.dart';
import '../../features/more/presentation/screens/help_screen.dart';
import '../../features/more/presentation/screens/about_screen.dart';
import '../../features/notifications/presentation/notifications_screen.dart';
import '../../features/contacts/presentation/widgets/add_contact_form.dart';
import '../../features/contacts/presentation/widgets/add_prospect_form.dart';
import '../../features/contacts/presentation/cubits/add_contact_cubit.dart';
import '../../features/contacts/presentation/cubits/add_prospect_cubit.dart';
import '../../features/contacts/data/contacts_repository_impl.dart';
import '../../features/contacts/data/datasources/contacts_remote_data_source.dart';
import '../../features/contacts/data/prospect_repository_impl.dart';
import '../../features/contacts/data/datasources/prospects_remote_data_source.dart';
import '../../features/contacts/domain/add_contact_use_case.dart';
import '../../features/contacts/domain/add_prospect_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/home/presentation/screens/kpis_screen.dart';
import '../../features/home/presentation/screens/goals_screen.dart';
import '../../features/home/presentation/screens/recent_activities_screen.dart';
import '../../features/home/presentation/screens/plan_meeting_screen.dart';

class AppRoutes {
  static const String login = '/';
  static const String otp = '/otp';
  static const String authTest = '/auth-test';
  static const String dashboard = '/dashboard';
  static const String offres = '/offres';
  static const String changeEntrepriseState = '/change-entreprise-state';
  static const String contacts = '/contacts';
  static const String calendar = '/calendar';
  static const String more = '/more';
  static const String wallet = '/wallet';
  static const String language = '/language';
  static const String privacy = '/privacy';
  static const String help = '/help';
  static const String about = '/about';
  static const String notifications = '/notifications';
  static const String kpis = '/kpis';
  static const String goals = '/goals';
  static const String recentActivities = '/recent-activities';
  static const String addProspect = '/add-prospect';
  static const String planMeeting = '/plan-meeting';

  static const String addContact = '/add-contact';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case otp:
        final phoneNumber = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => OtpScreen(phoneNumber: phoneNumber),
        );

      case authTest:
        return MaterialPageRoute(builder: (_) => const AuthTestScreen());

      case dashboard:
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(),
          settings: RouteSettings(name: dashboard),
        );

      case offres:
        return MaterialPageRoute(
          builder: (_) => const OffresScreen(),
          settings: RouteSettings(name: offres),
        );

      case changeEntrepriseState:
        return MaterialPageRoute(
          builder: (_) => ChangeEntrepriseStatePage(
            getCompaniesUseCase: GetCompaniesUseCase(CompanyRepositoryImpl()),
            getStatesUseCase: GetStatesUseCase(CompanyRepositoryImpl()),
            updateCompanyStateUseCase: UpdateCompanyStateUseCase(
              CompanyRepositoryImpl(),
            ),
          ),
          settings: RouteSettings(name: changeEntrepriseState),
        );

      case contacts:
        return MaterialPageRoute(
          builder: (_) => ContactsListScreen(),
          settings: RouteSettings(name: contacts),
        );

      case calendar:
        return MaterialPageRoute(
          builder: (_) => CalendarScreen(),
          settings: RouteSettings(name: calendar),
        );

      case more:
        return MaterialPageRoute(
          builder: (_) => const MoreScreen(),
          settings: RouteSettings(name: more),
        );

      case wallet:
        return MaterialPageRoute(builder: (_) => const WalletScreen());

      case language:
        return MaterialPageRoute(builder: (_) => const LanguageScreen());

      case privacy:
        return MaterialPageRoute(builder: (_) => const PrivacyScreen());

      case help:
        return MaterialPageRoute(builder: (_) => const HelpScreen());

      case about:
        return MaterialPageRoute(builder: (_) => const AboutScreen());

      case notifications:
        return MaterialPageRoute(builder: (_) => const NotificationsScreen());

      case addContact:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => AddContactCubit(
              AddContactUseCase(
                ContactsRepositoryImpl(
                  remoteDataSource: ContactsRemoteDataSource(),
                ),
              ),
            ),
            child: Scaffold(
              appBar: AppBar(
                title: const Text('Ajouter un contact'),
                backgroundColor: const Color(0xFF009640), // AppColors.primary
                foregroundColor: Colors.white,
              ),
              body: const AddContactForm(),
            ),
          ),
        );

      case addProspect:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => AddProspectCubit(
              AddProspectUseCase(
                ProspectRepositoryImpl(
                  remoteDataSource: ProspectsRemoteDataSource(),
                ),
              ),
            ),
            child: Scaffold(
              appBar: AppBar(
                title: const Text('Ajouter un prospect'),
                backgroundColor: const Color(0xFF009640), // AppColors.primary
                foregroundColor: Colors.white,
              ),
              body: const AddProspectForm(),
            ),
          ),
        );
      case kpis:
        return MaterialPageRoute(builder: (_) => const KPIsScreen());

      case goals:
        return MaterialPageRoute(builder: (_) => const GoalsScreen());

      case recentActivities:
        return MaterialPageRoute(
          builder: (_) => const RecentActivitiesScreen(),
        );

      case planMeeting:
        return MaterialPageRoute(builder: (_) => const PlanMeetingScreen());

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
