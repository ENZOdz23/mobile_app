// lib/features/contacts/presentation/widgets/contact_header.dart

import 'package:flutter/material.dart';
import '../../../../core/themes/app_theme.dart';

class ContactHeader extends StatelessWidget {
  final String name;
  final String initials;

  const ContactHeader({
    super.key,
    required this.name,
    required this.initials,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: AppColors.primary,
          child: Text(
            initials,
            style: TextStyle(
              color: AppColors.onPrimary,
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 12),
        Text(
          name,
          style: AppTextStyles.headlineMedium.copyWith(
            color: AppColors.secondary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}