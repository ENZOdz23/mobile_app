// lib/main.dart

import 'core/utils/utils.dart';
import 'package:flutter/services.dart';
import 'core/themes/app_theme.dart';
import 'core/config/routes.dart';
import 'core/api/api_client.dart';

void main() async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize API client
  await Api.initialize();

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

  runApp(const ProspectraApp());
}

class ProspectraApp extends StatelessWidget {
  const ProspectraApp({super.key});

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
            textScaler: TextScaler.linear(MediaQuery.of(context).textScaleFactor.clamp(0.8, 1.3)),
          ),
          child: child!,
        );
      },
    );
  }
}
