import 'package:flutter/material.dart';
import '../../../../core/themes/app_theme.dart';

class SettingsSection extends StatelessWidget {
  const SettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,  // Changed
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.secondary.withOpacity(0.1),  // Changed
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Paramètres',
            style: AppTextStyles.headlineMedium.copyWith(  // Changed
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 16),
          _buildSettingItem(
            icon: Icons.notifications,
            title: 'Notifications',
            onTap: () {},
          ),
          const Divider(height: 1),
          _buildSettingItem(
            icon: Icons.language,
            title: 'Langue',
            trailing: 'Français',
            onTap: () {},
          ),
          const Divider(height: 1),
          _buildSettingItem(
            icon: Icons.security,
            title: 'Confidentialité',
            onTap: () {},
          ),
          const Divider(height: 1),
          _buildSettingItem(
            icon: Icons.help,
            title: 'Aide et support',
            onTap: () {},
          ),
          const Divider(height: 1),
          _buildSettingItem(
            icon: Icons.info,
            title: 'À propos',
            onTap: () {},
          ),
          const Divider(height: 1),
          _buildSettingItem(
            icon: Icons.logout,
            title: 'Déconnexion',
            iconColor: AppColors.error,  // Changed
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    String? trailing,
    required VoidCallback onTap,
    Color? iconColor,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(icon, color: iconColor ?? AppColors.primary),  // Changed
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.bodyLarge.copyWith(  // Changed
                  color: iconColor ?? AppColors.onSurfaceLight,
                ),
              ),
            ),
            if (trailing != null)
              Text(
                trailing,
                style: AppTextStyles.bodyMedium.copyWith(  // Changed
                  color: AppColors.secondary.withOpacity(0.6),
                ),
              ),
            const SizedBox(width: 8),
            Icon(Icons.chevron_right, color: AppColors.secondary.withOpacity(0.5)),  // Changed
          ],
        ),
      ),
    );
  }
}
