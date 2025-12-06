// lib/core/config/routes.dart

import 'package:flutter/material.dart';
import '../../features/authentication/presentation/login_screen.dart';
import '../../features/authentication/presentation/otp_screen.dart';
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
import '../../features/contacts/presentation/cubit/add_contact_cubit.dart';
import '../../features/contacts/presentation/cubit/add_prospect_cubit.dart';
import '../../features/contacts/data/contacts_repository_impl.dart';
import '../../features/contacts/data/contacts_local_data_source.dart';
import '../../features/contacts/data/prospect_repository_impl.dart';
import '../../features/contacts/data/prospect_local_data_source.dart';
import '../../features/contacts/domain/add_contact_use_case.dart';
import '../../features/contacts/domain/add_prospect_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppRoutes {
  static const String login = '/';
  static const String otp = '/otp';
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

  static const String addContact = '/add-contact';
  static const String addProspect = '/add-prospect';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case otp:
        final phoneNumber = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => OtpScreen(phoneNumber: phoneNumber),
        );

      case dashboard:
        return MaterialPageRoute(builder: (_) => const HomeScreen());

      case offres:
        return MaterialPageRoute(builder: (_) => const OffresScreen());

      case changeEntrepriseState:
        return MaterialPageRoute(
          builder: (_) => ChangeEntrepriseStatePage(
            getCompaniesUseCase: GetCompaniesUseCase(CompanyRepositoryImpl()),
            getStatesUseCase: GetStatesUseCase(CompanyRepositoryImpl()),
            updateCompanyStateUseCase: UpdateCompanyStateUseCase(
              CompanyRepositoryImpl(),
            ),
          ),
        );

      case contacts:
        return MaterialPageRoute(builder: (_) => ContactsListScreen());

      case calendar:
        return MaterialPageRoute(builder: (_) => CalendarScreen());

      case more:
        return MaterialPageRoute(builder: (_) => const MoreScreen());

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
                ContactsRepositoryImpl(localDataSource: ContactsLocalDataSource()),
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
                ProspectRepositoryImpl(localDataSource: ProspectsLocalDataSource()),
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

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
