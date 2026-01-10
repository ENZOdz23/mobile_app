// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/more/presentation/cubit/language_cubit.dart';
import 'features/more/presentation/cubit/language_state.dart';
import 'core/storage/local_storage_service.dart';
import 'core/i18n/l10n/app_localizations.dart';

import 'core/utils/utils.dart';
import 'package:flutter/services.dart';
import 'core/themes/app_theme.dart';
import 'core/config/routes.dart';
import 'core/api/api_client.dart';
import 'features/offres/data/offer_repository.dart';
import 'core/utils/motivation_manager.dart';

void main() async {
  await SentryFlutter.init(
    (options) {
      options
        ..dsn =
            'https://ae255c146a247f1455edc35904c3b715@o4510688299974656.ingest.de.sentry.io/4510688307183696'
        ..tracesSampleRate = 1.0;
    },
    appRunner: () async {
      // Ensure Flutter binding is initialized
      WidgetsFlutterBinding.ensureInitialized();

      // Initialize Firebase
      await Firebase.initializeApp();

      // Pass all uncaught "fatal" errors from the framework to Crashlytics
      FlutterError.onError = (errorDetails) {
        FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
      };

      // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
      PlatformDispatcher.instance.onError = (error, stack) {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
        return true;
      };

      // Initialize API client
      await Api.initialize();

      // Initialize offres database with seed data
      final offerRepository = OfferRepository();
      await offerRepository.initializeData();

  // Initialize LocalStorageService
  final localStorage = await LocalStorageService.getInstance();

  runApp(
    BlocProvider(
      create: (context) => LanguageCubit(localStorage)..loadLanguage(),
      child: const ProspectraApp(),
    ),
  );
}

class ProspectraApp extends StatelessWidget {
  const ProspectraApp({super.key});

  // Firebase Analytics instance
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(
    analytics: analytics,
  );

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageCubit, LanguageState>(
      builder: (context, state) {
        return MaterialApp(
          // App configuration
          title: 'Prospectra - Mobilis',
          debugShowCheckedModeBanner: false,
          navigatorKey: navigatorKey,

          // Localization
          locale: state.locale,
          supportedLocales: const [Locale('en'), Locale('fr'), Locale('ar')],
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],

          // Theme configuration
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: ThemeMode.light, // Default to light mode
          // Routing
          initialRoute: AppRoutes.login,
          onGenerateRoute: AppRoutes.generateRoute,

          // Builder to handle text scaling
          builder: (context, child) {
            return MediaQuery(
              // Prevent text scaling beyond reasonable limits
              data: MediaQuery.of(context).copyWith(
                textScaler: TextScaler.linear(
                  MediaQuery.of(context).textScaleFactor.clamp(0.8, 1.3),
                ),
              ),
              child: child!,
            );
          },
        );
      },
    );
  }
}
