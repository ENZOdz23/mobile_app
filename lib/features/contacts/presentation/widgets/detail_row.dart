// lib/features/contacts/presentation/widgets/detail_row.dart

import 'package:flutter/material.dart';
import '../../../../core/themes/app_theme.dart';

class DetailRow {
  final IconData icon;
  final String label;
  final String value;
  final bool hasInfo;

  DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    this.hasInfo = false,
  });
}

class DetailRowWidget extends StatelessWidget {
  final DetailRow detail;

  const DetailRowWidget({
    super.key,
    required this.detail,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(detail.icon, color: AppColors.primary, size: 20),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  detail.label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  detail.value,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.secondary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          if (detail.hasInfo)
            Icon(Icons.info_outline, color: AppColors.accent, size: 20),
        ],
      ),
    );
  }
}