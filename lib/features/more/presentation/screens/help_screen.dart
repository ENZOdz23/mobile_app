import 'package:flutter/material.dart';
import '../../../../shared/components/base_scaffold.dart';
import '../../../../core/themes/app_theme.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: 'Aide et support',
      showBottomNav: false,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildContactCard(),
          const SizedBox(height: 24),
          Text(
            'FAQ',
            style: AppTextStyles.headlineMedium.copyWith(fontSize: 18),
          ),
          const SizedBox(height: 16),
          _buildFaqItem(
            'Comment changer mon mot de passe ?',
            'Allez dans Paramètres > Sécurité > Changer le mot de passe.',
          ),
          _buildFaqItem(
            'Comment contacter le support ?',
            'Vous pouvez nous appeler ou nous envoyer un email via les boutons ci-dessus.',
          ),
          _buildFaqItem(
            'L\'application ne se synchronise pas',
            'Vérifiez votre connexion internet et essayez de tirer vers le bas pour rafraîchir.',
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
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
        children: [
          const Text(
            'Besoin d\'aide ?',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Notre équipe est disponible 24/7',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.phone),
                  label: const Text('Appeler'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.email),
                  label: const Text('Email'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFaqItem(String question, String answer) {
    return ExpansionTile(
      title: Text(
        question,
        style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Text(
            answer,
            style: AppTextStyles.bodyMedium.copyWith(color: Colors.grey[700]),
          ),
        ),
      ],
    );
  }
}
