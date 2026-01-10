import 'package:flutter/material.dart';
import '../../../../core/themes/app_theme.dart';
import '../statistics_screen.dart';

class QuickLinksSection extends StatelessWidget {
  const QuickLinksSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight, // Changed
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.secondary.withOpacity(0.1), // Changed
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Accès rapide',
            style: AppTextStyles.headlineMedium.copyWith(
              // Changed
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 16),
          _buildQuickLinkItem(
            icon: Icons.calendar_today,
            title: 'Calendrier',
            onTap: () {
              Navigator.pushNamed(context, '/calendar');
            },
          ),
          const Divider(height: 1),
          _buildQuickLinkItem(
            icon: Icons.analytics,
            title: 'Statistiques',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const StatisticsScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildQuickLinkItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary), // Changed
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.bodyLarge, // Changed
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: AppColors.secondary.withOpacity(0.5),
            ), // Changed
          ],
        ),
      ),
    );
  }
}
