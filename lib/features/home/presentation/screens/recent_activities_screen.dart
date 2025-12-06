import 'package:flutter/material.dart';
import '../../../../shared/components/base_scaffold.dart';
import '../../../../core/themes/app_theme.dart';

class RecentActivitiesScreen extends StatelessWidget {
  const RecentActivitiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: 'Activités récentes',
      showBottomNav: false,
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 10,
        itemBuilder: (context, index) {
          return _buildActivityItem(index);
        },
      ),
    );
  }

  Widget _buildActivityItem(int index) {
    final activities = [
      {
        'title': 'Contrat signé',
        'subtitle': 'Entreprise ABC',
        'icon': Icons.check_circle,
        'color': AppColors.primary,
      },
      {
        'title': 'RDV Client',
        'subtitle': 'Client XYZ',
        'icon': Icons.event,
        'color': Colors.blue,
      },
      {
        'title': 'Appel sortant',
        'subtitle': 'Société DEF',
        'icon': Icons.phone,
        'color': Colors.orange,
      },
      {
        'title': 'Email envoyé',
        'subtitle': 'Proposition GHI',
        'icon': Icons.email,
        'color': Colors.purple,
      },
    ];

    final activity = activities[index % activities.length];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: (activity['color'] as Color).withOpacity(0.1),
          child: Icon(
            activity['icon'] as IconData,
            color: activity['color'] as Color,
          ),
        ),
        title: Text(
          activity['title'] as String,
          style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          activity['subtitle'] as String,
          style: AppTextStyles.bodyMedium.copyWith(color: Colors.grey),
        ),
        trailing: Text(
          'Il y a ${index + 1}h',
          style: AppTextStyles.bodyMedium.copyWith(
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
