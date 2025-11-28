// lib/shared/components/custom_app_bar.dart
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;

  const CustomAppBar({super.key, required this.title, this.actions});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255), // Green from design
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image.asset(
          'assets/images/logo.png',
          fit: BoxFit.contain,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.green,
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: actions ??
          [
            IconButton(
              icon: const Icon(Icons.notifications_outlined, color: Colors.green),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.search, color: Colors.green),
              onPressed: () {},
            ),
          ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}