import 'package:flutter/material.dart';
import '../../../../../core/themes/app_theme.dart';

class LoginRequestButton extends StatelessWidget {
  final bool loading;
  final VoidCallback onPressed;

  const LoginRequestButton({
    super.key,
    required this.loading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: loading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.accent,
        foregroundColor: AppColors.onPrimary,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 0,
      ),
      child: loading
          ? SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.onPrimary),
              ),
            )
          : const Text('Demander le code OTP', style: AppTextStyles.button),
    );
  }
}
