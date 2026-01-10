// lib/shared/components/custom_app_bar.dart
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showBackButton;

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.showBackButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color.fromARGB(
        255,
        255,
        255,
        255,
      ), // Green from design
      elevation: 0,
      leading: showBackButton
          ? const BackButton(color: Colors.green)
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset('assets/images/logo.png', fit: BoxFit.contain),
            ),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.green,
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: actions ?? [],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
