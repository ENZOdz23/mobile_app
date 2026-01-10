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
