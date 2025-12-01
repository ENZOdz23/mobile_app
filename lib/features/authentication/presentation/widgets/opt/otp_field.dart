import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../../core/themes/app_theme.dart';

class OtpField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool hasError;
  final Function(String value) onChanged;
  final VoidCallback onTap;

  const OtpField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.hasError,
    required this.onChanged,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 60,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: hasError
              ? AppColors.error
              : controller.text.isNotEmpty
                  ? AppColors.accent
                  : Colors.grey[300]!,
          width: 2,
        ),
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        style: Theme.of(
          context,
        ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
        decoration: const InputDecoration(
          border: InputBorder.none,
          counterText: '',
        ),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        onChanged: onChanged,
        onTap: onTap,
      ),
    );
  }
}
