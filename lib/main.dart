// lib/main.dart

import 'dart:ui';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
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

      // Set preferred orientations (portrait only for mobile app)
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);

      // Set system UI overlay style
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: Colors.white,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
      );

      // Start motivation reminder
      MotivationManager.start();

      runApp(const ProspectraApp());
    },
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
    return MaterialApp(
      // App configuration
      title: 'Prospectra - Mobilis',
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,

      // Theme configuration
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.light, // Default to light mode
      // Routing
      initialRoute: AppRoutes.login,
      onGenerateRoute: AppRoutes.generateRoute,
      navigatorObservers: [SentryNavigatorObserver(), observer],

      // Localization (add when implementing multi-language support)
      // locale: const Locale('fr', 'DZ'), // French (Algeria)
      // supportedLocales: const [
      //   Locale('fr', 'DZ'), // French
      //   Locale('ar', 'DZ'), // Arabic
      // ],

      // Builder for global configurations
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
  }
}
