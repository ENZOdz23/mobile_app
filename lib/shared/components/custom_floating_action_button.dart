// lib/shared/components/custom_floating_action_button.dart
import 'package:flutter/material.dart';

class CustomFloatingActionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isExpanded;

  const CustomFloatingActionButton({
    super.key,
    required this.onPressed,
    required this.isExpanded,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: const Color(0xFF4CAF50),
      child: AnimatedRotation(
        turns: isExpanded ? 0.125 : 0,
        duration: const Duration(milliseconds: 200),
        child: Icon(
          isExpanded ? Icons.close : Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}