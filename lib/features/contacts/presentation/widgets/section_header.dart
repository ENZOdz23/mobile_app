// lib/features/contacts/presentation/widgets/section_header.dart

import 'package:flutter/material.dart';
import '../../../../core/themes/app_theme.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final IconData? actionIcon;
  final VoidCallback? onActionPressed;
  final String? actionTooltip;

  const SectionHeader({
    super.key,
    required this.title,
    this.actionIcon,
    this.onActionPressed,
    this.actionTooltip,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppTextStyles.headlineMedium.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.secondary,
            fontSize: 18,
          ),
        ),
        if (actionIcon != null && onActionPressed != null)
          IconButton(
            icon: Icon(actionIcon, color: AppColors.primary),
            onPressed: onActionPressed,
            tooltip: actionTooltip,
          ),
      ],
    );
  }
}