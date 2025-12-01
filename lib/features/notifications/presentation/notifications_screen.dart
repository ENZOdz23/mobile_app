import 'package:flutter/material.dart';
import '../../../shared/components/base_scaffold.dart';
import '../../../core/themes/app_theme.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: 'Notifications',
      showBottomNav: false,
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 10,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: AppColors.primary.withOpacity(0.1),
                child: const Icon(
                  Icons.notifications,
                  color: AppColors.primary,
                ),
              ),
              title: Text(
                'Notification #${index + 1}',
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                'Ceci est un exemple de notification pour tester l\'écran.',
                style: AppTextStyles.bodyMedium.copyWith(color: Colors.grey),
              ),
              trailing: Text(
                '12:30',
                style: AppTextStyles.bodyMedium.copyWith(color: Colors.grey),
              ),
            ),
          );
        },
      ),
    );
  }
}
