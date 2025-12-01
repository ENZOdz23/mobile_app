import 'package:flutter/material.dart';
import '../../../../shared/components/base_scaffold.dart';
import '../../../../core/themes/app_theme.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: 'Confidentialité',
      showBottomNav: false,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSection(
            'Politique de confidentialité',
            'Nous prenons votre vie privée très au sérieux. Toutes vos données sont chiffrées et stockées de manière sécurisée.',
          ),
          const SizedBox(height: 24),
          _buildSection(
            'Utilisation des données',
            'Vos données sont utilisées uniquement pour améliorer votre expérience utilisateur et vous fournir des services personnalisés.',
          ),
          const SizedBox(height: 24),
          _buildToggleItem('Partager les données d\'utilisation', true),
          const Divider(),
          _buildToggleItem('Autoriser la géolocalisation', true),
          const Divider(),
          _buildToggleItem('Notifications marketing', false),
        ],
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.headlineMedium.copyWith(fontSize: 18)),
        const SizedBox(height: 8),
        Text(
          content,
          style: AppTextStyles.bodyLarge.copyWith(color: Colors.grey[700]),
        ),
      ],
    );
  }

  Widget _buildToggleItem(String title, bool value) {
    return SwitchListTile(
      value: value,
      onChanged: (val) {},
      title: Text(title, style: AppTextStyles.bodyLarge),
      activeColor: AppColors.primary,
    );
  }
}
