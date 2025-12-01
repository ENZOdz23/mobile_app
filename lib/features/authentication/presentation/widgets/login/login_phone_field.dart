import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../../core/themes/app_theme.dart';

class LoginPhoneField extends StatelessWidget {
  final TextEditingController controller;
  final bool hasError;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;

  const LoginPhoneField({
    super.key,
    required this.controller,
    this.hasError = false,
    this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: hasError ? AppColors.error : Colors.grey[300]!,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: controller,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Numéro de téléphone',
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                errorStyle: TextStyle(height: 0),
              ),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
              validator: validator,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}
