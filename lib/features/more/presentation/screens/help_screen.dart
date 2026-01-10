import 'package:flutter/material.dart';
import '../../../../shared/components/base_scaffold.dart';
import '../../../../core/themes/app_theme.dart';
import '../../../../core/i18n/l10n/app_localizations.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context)!;
    return BaseScaffold(
      title: s.helpAndSupport,
      showBottomNav: false,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildContactCard(context),
          const SizedBox(height: 24),
          Text(
            s.faq,
            style: AppTextStyles.headlineMedium.copyWith(fontSize: 18),
          ),
          const SizedBox(height: 16),
          _buildFaqItem(
            s.howToChangePassword,
            s.howToChangePasswordAnswer,
          ),
          _buildFaqItem(
            s.howToContactSupport,
            s.howToContactSupportAnswer,
          ),
          _buildFaqItem(
            s.appNotSyncing,
            s.appNotSyncingAnswer,
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard(BuildContext context) {
    final s = S.of(context)!;
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
          Text(
            s.needHelp,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            s.supportAvailable,
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.phone),
                  label: Text(s.call),
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
                  label: Text(s.email),
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
