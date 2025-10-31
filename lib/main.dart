import 'package:crm_sales_performance_mobilis/core/themes/app_theme.dart';
import 'package:flutter/material.dart';
// Import your homepage widget
import 'features/home/presentation/home_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: lightTheme,
      darkTheme: darkTheme,
      home: HomeScreen(), // Change this to your homepage widget
    );
  }
}
