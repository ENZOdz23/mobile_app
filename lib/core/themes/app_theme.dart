// lib/core/themes/app_theme.dart

import 'package:flutter/material.dart';

// Mobilis color palette
class AppColors {
  static const primary = Color(0xFF009640);
  static const secondary = Color(0xFF212121);
  static const accent = Color(0xFF43B02A);
  static const backgroundLight = Color(0xFFF8F8F8);
  static const surfaceLight = Color(0xFFFFFFFF);
  static const backgroundDark = Color(0xFF121212);
  static const surfaceDark = Color(0xFF1E1E1E);
  static const error = Color(0xFFD32F2F);
  static const onPrimary = Color(0xFFFFFFFF);
  static const onSecondary = Color(0xFFFFFFFF);
  static const onBackgroundLight = Color(0xFF212121);
  static const onBackgroundDark = Color(0xFFFFFFFF);
  static const onSurfaceLight = Color(0xFF212121);
  static const onSurfaceDark = Color(0xFFFFFFFF);
}

// Base app typography
class AppTextStyles {
  static const headlineLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
  );

  static const headlineMedium = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
  );

  static const bodyLarge = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.normal,
  );

  static const bodyMedium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
  );

  static const button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.onPrimary,
  );
}

// Base class to provide common ThemeData properties
abstract class AppBaseTheme {
  Color get primaryColor;
  Color get secondaryColor;
  Color get accentColor;
  Color get backgroundColor;
  Color get surfaceColor;
  Color get onPrimaryColor;
  Color get onSecondaryColor;
  Color get onBackgroundColor;
  Color get onSurfaceColor;
  Color get errorColor;

  TextTheme get textTheme => TextTheme(
        headlineLarge: AppTextStyles.headlineLarge.copyWith(color: onBackgroundColor),
        headlineMedium: AppTextStyles.headlineMedium.copyWith(color: onBackgroundColor),
        bodyLarge: AppTextStyles.bodyLarge.copyWith(color: onBackgroundColor),
        bodyMedium: AppTextStyles.bodyMedium.copyWith(color: onBackgroundColor),
        labelLarge: AppTextStyles.button,
      );

  AppBarTheme get appBarTheme => AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: onPrimaryColor,
        elevation: 0,
        titleTextStyle: AppTextStyles.headlineMedium.copyWith(color: onPrimaryColor),
      );

  FloatingActionButtonThemeData get floatingActionButtonTheme => FloatingActionButtonThemeData(
        backgroundColor: accentColor,
        foregroundColor: onPrimaryColor,
      );

  ButtonThemeData get buttonTheme => ButtonThemeData(
        buttonColor: primaryColor,
        textTheme: ButtonTextTheme.primary,
      );

  ThemeData get themeData => ThemeData(
        brightness: _brightness,
        primaryColor: primaryColor,
        scaffoldBackgroundColor: backgroundColor,
        colorScheme: ColorScheme(
          brightness: _brightness,
          primary: primaryColor,
          onPrimary: onPrimaryColor,
          secondary: secondaryColor,
          onSecondary: onSecondaryColor,
          surface: surfaceColor,
          onSurface: onSurfaceColor,
          error: errorColor,
          onError: AppColors.onPrimary,
          tertiary: accentColor,
          onTertiary: onPrimaryColor,
        ),
        appBarTheme: appBarTheme,
        floatingActionButtonTheme: floatingActionButtonTheme,
        buttonTheme: buttonTheme,
        cardColor: surfaceColor,
        textTheme: textTheme,
      );

  Brightness get _brightness;
}

// Light theme implementation
class AppLightTheme extends AppBaseTheme {
  @override
  final Color primaryColor = AppColors.primary;

  @override
  final Color secondaryColor = AppColors.secondary;

  @override
  final Color accentColor = AppColors.accent;

  @override
  final Color backgroundColor = AppColors.backgroundLight;

  @override
  final Color surfaceColor = AppColors.surfaceLight;

  @override
  final Color onPrimaryColor = AppColors.onPrimary;

  @override
  final Color onSecondaryColor = AppColors.onSecondary;

  @override
  final Color onBackgroundColor = AppColors.onBackgroundLight;

  @override
  final Color onSurfaceColor = AppColors.onSurfaceLight;

  @override
  final Color errorColor = AppColors.error;

  @override
  Brightness get _brightness => Brightness.light;
}

// Dark theme implementation
class AppDarkTheme extends AppBaseTheme {
  @override
  final Color primaryColor = AppColors.primary;

  @override
  final Color secondaryColor = AppColors.secondary;

  @override
  final Color accentColor = AppColors.accent;

  @override
  final Color backgroundColor = AppColors.backgroundDark;

  @override
  final Color surfaceColor = AppColors.surfaceDark;

  @override
  final Color onPrimaryColor = AppColors.onPrimary;

  @override
  final Color onSecondaryColor = AppColors.onSecondary;

  @override
  final Color onBackgroundColor = AppColors.onBackgroundDark;

  @override
  final Color onSurfaceColor = AppColors.onSurfaceDark;

  @override
  final Color errorColor = AppColors.error;

  @override
  Brightness get _brightness => Brightness.dark;
}

// Public getters for easy import
final ThemeData lightTheme = AppLightTheme().themeData;
final ThemeData darkTheme = AppDarkTheme().themeData;
