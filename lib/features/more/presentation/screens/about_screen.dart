import 'package:flutter/material.dart';
import '../../../../shared/components/base_scaffold.dart';
import '../../../../core/themes/app_theme.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: 'À propos',
      showBottomNav: false,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.business,
                size: 50,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Prospectra',
              style: AppTextStyles.headlineLarge.copyWith(
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Version 1.0.0',
              style: AppTextStyles.bodyLarge.copyWith(color: Colors.grey),
            ),
            const SizedBox(height: 48),
            const Text(
              '© 2025 Mobilis. Tous droits réservés.',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
