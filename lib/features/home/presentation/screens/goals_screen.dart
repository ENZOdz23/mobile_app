import 'package:flutter/material.dart';
import '../../../../shared/components/base_scaffold.dart';
import '../../../../core/themes/app_theme.dart';

class GoalsScreen extends StatelessWidget {
  const GoalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: 'Objectifs du mois',
      showBottomNav: false,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildGoalCard('Chiffre d\'affaires', 1200000, 1500000, 'DZD'),
          const SizedBox(height: 16),
          _buildGoalCard('Nouveaux clients', 24, 30, 'Clients'),
          const SizedBox(height: 16),
          _buildGoalCard('Rendez-vous', 18, 25, 'RDV'),
          const SizedBox(height: 16),
          _buildGoalCard('Contrats signés', 8, 10, 'Contrats'),
        ],
      ),
    );
  }

  Widget _buildGoalCard(String title, int current, int target, String unit) {
    final progress = current / target;
    final percentage = (progress * 100).toInt();

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: AppTextStyles.headlineMedium.copyWith(fontSize: 18),
              ),
              Text(
                '$percentage%',
                style: AppTextStyles.headlineMedium.copyWith(
                  fontSize: 18,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 12,
              backgroundColor: Colors.grey[200],
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.primary,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Actuel: $current $unit',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              Text(
                'Cible: $target $unit',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
