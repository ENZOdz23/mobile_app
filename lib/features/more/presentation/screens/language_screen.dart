import 'package:flutter/material.dart';
import '../../../../shared/components/base_scaffold.dart';
import '../../../../core/themes/app_theme.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  String _selectedLanguage = 'fr';

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: 'Langue',
      showBottomNav: false,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildLanguageItem('fr', 'Français', 'Français'),
          const Divider(),
          _buildLanguageItem('ar', 'العربية', 'Arabe'),
        ],
      ),
    );
  }

  Widget _buildLanguageItem(String code, String nativeName, String name) {
    final isSelected = _selectedLanguage == code;
    return ListTile(
      onTap: () {
        setState(() {
          _selectedLanguage = code;
        });
      },
      title: Text(
        nativeName,
        style: AppTextStyles.bodyLarge.copyWith(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      subtitle: Text(name),
      trailing: isSelected
          ? const Icon(Icons.check_circle, color: AppColors.primary)
          : null,
    );
  }
}
