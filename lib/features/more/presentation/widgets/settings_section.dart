import 'package:flutter/material.dart';
import '../../../../core/themes/app_theme.dart';
import '../../../../core/config/routes.dart';
import '../../../authentication/presentation/cubit/auth_cubit.dart';
import '../../../authentication/domain/request_otp_usecase.dart';
import '../../../authentication/domain/verify_otp_usecase.dart';
import '../../../authentication/domain/resend_otp_usecase.dart';
import '../../../authentication/data/otp_repository_impl.dart';
import '../../../authentication/data/login_repository_impl.dart';
import '../../../authentication/data/datasources/auth_remote_data_source.dart';
import '../../../../core/i18n/l10n/app_localizations.dart';

class SettingsSection extends StatelessWidget {
  const SettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context)!;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight, // Changed
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.secondary.withOpacity(0.1), // Changed
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            s.settings,
            style: AppTextStyles.headlineMedium.copyWith(
              // Changed
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 16),
          _buildSettingItem(
            icon: Icons.language,
            title: s.language,
            // trailing: 'Français', // Optional: could show current language
            onTap: () {
              Navigator.pushNamed(context, '/language');
            },
          ),
          const Divider(height: 1),
          // Privacy, Help, About remain hardcoded for now as they were not in the ARB or I can add them if I want to be thorough but the plan only had specific strings.
          // The ARB file has: settings, logout, language. It does not have privacy, help, about.
          // I'll stick to what is in ARB.
          _buildSettingItem(
            icon: Icons.security,
            title: s.privacy,
            onTap: () {
              Navigator.pushNamed(context, '/privacy');
            },
          ),
          const Divider(height: 1),
          _buildSettingItem(
            icon: Icons.help,
            title: s.helpAndSupport,
            onTap: () {
              Navigator.pushNamed(context, '/help');
            },
          ),
          const Divider(height: 1),
          _buildSettingItem(
            icon: Icons.info,
            title: s.about,
            onTap: () {
              Navigator.pushNamed(context, '/about');
            },
          ),
          const Divider(height: 1),
          _buildSettingItem(
            icon: Icons.logout,
            title: s.logout,
            iconColor: AppColors.error, // Changed
            onTap: () => _showLogoutDialog(context),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        final s = S.of(context)!;
        return AlertDialog(
          title: Text(s.logout),
          content: Text(s.logoutConfirmation),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(s.cancel),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(dialogContext).pop(); // Close dialog

                // Create AuthCubit and perform logout
                final authCubit = AuthCubit(
                  requestOtpUseCase: RequestOtpUseCase(
                    LoginRepositoryImpl(
                      remoteDataSource: AuthRemoteDataSource(),
                    ),
                  ),
                  verifyOtpUseCase: VerifyOtpUseCase(
                    OtpRepositoryImpl(remoteDataSource: AuthRemoteDataSource()),
                  ),
                  resendOtpUseCase: ResendOtpUseCase(
                    OtpRepositoryImpl(remoteDataSource: AuthRemoteDataSource()),
                  ),
                );

                await authCubit.logout();

                // Navigate to login and remove all previous routes
                if (context.mounted) {
                  Navigator.of(
                    context,
                  ).pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
                }
              },
              style: TextButton.styleFrom(foregroundColor: AppColors.error),
              child: Text(s.logout),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    String? trailing,
    required VoidCallback onTap,
    Color? iconColor,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(icon, color: iconColor ?? AppColors.primary), // Changed
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.bodyLarge.copyWith(
                  // Changed
                  color: iconColor ?? AppColors.onSurfaceLight,
                ),
              ),
            ),
            if (trailing != null)
              Text(
                trailing,
                style: AppTextStyles.bodyMedium.copyWith(
                  // Changed
                  color: AppColors.secondary.withOpacity(0.6),
                ),
              ),
            const SizedBox(width: 8),
            Icon(
              Icons.chevron_right,
              color: AppColors.secondary.withOpacity(0.5),
            ), // Changed
          ],
        ),
      ),
    );
  }
}
