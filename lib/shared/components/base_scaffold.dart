// lib/shared/components/base_scaffold.dart
import 'package:flutter/material.dart';
import 'custom_app_bar.dart';
import 'custom_bottom_nav_bar.dart';

class BaseScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final int currentIndex;
  final ValueChanged<int> onNavTap;

  const BaseScaffold({
    required this.title,
    required this.body,
    required this.currentIndex,
    required this.onNavTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: title),
      body: body,
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: currentIndex,
        onTap: onNavTap,
      ),
    );
  }
}
