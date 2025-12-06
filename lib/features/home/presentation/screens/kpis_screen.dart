import 'package:flutter/material.dart';
import '../../../../shared/components/base_scaffold.dart';
import '../../../../core/themes/app_theme.dart';

class KPIsScreen extends StatelessWidget {
  const KPIsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: 'Mes Indicateurs',
      showBottomNav: false,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildKPICard(
              'Ventes du mois',
              '1.2M DZD',
              Icons.trending_up,
              const Color(0xFF4CAF50),
              '+12% vs mois dernier',
            ),
            const SizedBox(height: 16),
            _buildKPICard(
              'Nouveaux clients',
              '24',
              Icons.person_add,
              const Color(0xFF2196F3),
              '+8 vs mois dernier',
            ),
            const SizedBox(height: 16),
            _buildKPICard(
              'RDV réalisés',
              '18/22',
              Icons.event_available,
              const Color(0xFFFF9800),
              '82% de l\'objectif',
            ),
            const SizedBox(height: 16),
            _buildKPICard(
              'Prospects actifs',
              '42',
              Icons.people_outline,
              const Color(0xFF9C27B0),
              '+5 vs mois dernier',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKPICard(
    String title,
    String value,
    IconData icon,
    Color color,
    String subtitle,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 32),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: AppTextStyles.headlineMedium.copyWith(
                    color: AppColors.secondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
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
