// lib/features/home/presentation/widgets/prospect_status_card.dart

import 'package:flutter/material.dart';
import '../../../../core/themes/app_theme.dart';
import '../../models/prospect_status_count.dart';

class ProspectStatusCard extends StatelessWidget {
  final ProspectStatusCount statusCount;

  const ProspectStatusCard({
    super.key,
    required this.statusCount,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final surfaceColor = theme.colorScheme.surface;
    final onSurfaceColor = theme.colorScheme.onSurface;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Prospects par statut',
            style: AppTextStyles.headlineMedium.copyWith(
              color: onSurfaceColor,
            ),
          ),
          const SizedBox(height: 16),
          _buildStatusItem(
            context,
            'Intéressé',
            statusCount.interested,
            AppColors.accent,
            onSurfaceColor,
          ),
          const SizedBox(height: 12),
          _buildStatusItem(
            context,
            'Non intéressé',
            statusCount.notInterested,
            AppColors.error,
            onSurfaceColor,
          ),
          const SizedBox(height: 12),
          _buildStatusItem(
            context,
            'Sans réponse',
            statusCount.notAnswered,
            Colors.grey,
            onSurfaceColor,
          ),
        ],
      ),
    );
  }

  Widget _buildStatusItem(
    BuildContext context,
    String label,
    int count,
    Color color,
    Color textColor,
  ) {
    final total = statusCount.total;
    final percentage = total > 0 ? (count / total * 100) : 0.0;

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    label,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: textColor,
                    ),
                  ),
                  Text(
                    '$count',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: textColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: total > 0 ? count / total : 0,
                  backgroundColor: color.withOpacity(0.1),
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                  minHeight: 6,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '${percentage.toStringAsFixed(0)}%',
          style: AppTextStyles.bodyMedium.copyWith(
            color: textColor.withOpacity(0.7),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

