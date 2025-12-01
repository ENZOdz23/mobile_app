// lib/features/contacts/presentation/widgets/company_header.dart

import 'package:flutter/material.dart';
import '../../../../core/themes/app_theme.dart';

class CompanyHeader extends StatelessWidget {
  final String companyName;
  final String address;
  final String initials;

  const CompanyHeader({
    super.key,
    required this.companyName,
    required this.address,
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
          companyName,
          style: AppTextStyles.headlineMedium.copyWith(
            color: AppColors.secondary,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
          textAlign: TextAlign.center,
        ),
        if (address.isNotEmpty) ...[
          SizedBox(height: 8),
          Text(
            address,
            style: AppTextStyles.bodyMedium.copyWith(
              color: Colors.grey[600],
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}