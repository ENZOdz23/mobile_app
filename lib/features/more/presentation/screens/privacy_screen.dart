import 'package:flutter/material.dart';
import '../../../../shared/components/base_scaffold.dart';
import '../../../../core/themes/app_theme.dart';
import '../../../../core/i18n/l10n/app_localizations.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context)!;
    return BaseScaffold(
      title: s.privacy,
      showBottomNav: false,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSection(
            s.privacyPolicy,
            s.privacyPolicyContent,
          ),
          const SizedBox(height: 24),
          _buildSection(
            s.dataUsage,
            s.dataUsageContent,
          ),
          const SizedBox(height: 24),
          _buildToggleItem(s.shareUsageData, true),
          const Divider(),
          _buildToggleItem(s.allowGeolocation, true),
          const Divider(),
          _buildToggleItem(s.marketingNotifications, false),
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
      activeThumbColor: AppColors.primary,
    );
  }
}
