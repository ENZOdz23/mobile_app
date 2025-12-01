// lib/features/contacts/presentation/widgets/quick_action_button.dart

import 'package:flutter/material.dart';
import '../../../../core/themes/app_theme.dart';

class QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;

  const QuickActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          color: Colors.transparent,
          shape: CircleBorder(),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(30),
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey[300]!, width: 1),
              ),
              child: Icon(icon, size: 28, color: color),
            ),
          ),
        ),
        SizedBox(height: 6),
        Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.secondary,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}