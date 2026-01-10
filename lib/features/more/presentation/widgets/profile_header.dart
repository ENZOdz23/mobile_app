import 'package:flutter/material.dart';
import '../../models/user_profile.dart';
import '../../../../core/themes/app_theme.dart';

class ProfileHeader extends StatelessWidget {
  final UserProfile profile;

  const ProfileHeader({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary, // Changed from Color(0xFF4CAF50)
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profile.role,
                  style: AppTextStyles.headlineMedium.copyWith(
                    // Changed
                    color: AppColors.onPrimary,
                  ),
                ),
                const SizedBox(height: 4),

                const SizedBox(height: 8),
                Text(
                  profile.email,
                  style: AppTextStyles.bodyMedium.copyWith(
                    // Changed
                    fontSize: 12,
                    color: AppColors.onPrimary.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
