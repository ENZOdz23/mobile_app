import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/themes/app_theme.dart';
import '../../../../core/i18n/l10n/app_localizations.dart';
import '../cubit/language_cubit.dart';
import '../cubit/language_state.dart';

class LanguageScreen extends StatelessWidget {
  static const String routeName = '/language';

  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(s.language),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocBuilder<LanguageCubit, LanguageState>(
        builder: (context, state) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildLanguageItem(
                context,
                title: s.english,
                code: 'en',
                isSelected: state.locale.languageCode == 'en',
                onTap: () {
                  context.read<LanguageCubit>().changeLanguage('en');
                },
              ),
              const SizedBox(height: 12),
              _buildLanguageItem(
                context,
                title: s.french,
                code: 'fr',
                isSelected: state.locale.languageCode == 'fr',
                onTap: () {
                  context.read<LanguageCubit>().changeLanguage('fr');
                },
              ),
              const SizedBox(height: 12),
              _buildLanguageItem(
                context,
                title: s.arabic,
                code: 'ar',
                isSelected: state.locale.languageCode == 'ar',
                onTap: () {
                  context.read<LanguageCubit>().changeLanguage('ar');
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildLanguageItem(
    BuildContext context, {
    required String title,
    required String code,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? AppColors.primary : Colors.grey.shade200,
          width: isSelected ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary.withOpacity(0.1)
                        : Colors.grey.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      code.toUpperCase(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isSelected
                            ? AppColors.primary
                            : Colors.grey.shade600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (isSelected)
                  Icon(Icons.check_circle, color: AppColors.primary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
