import 'package:flutter/material.dart';

class ConfirmationMessageBar extends StatelessWidget {
  final bool visible;
  final String message;

  const ConfirmationMessageBar({
    Key? key,
    required this.visible,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!visible) return SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12),
      color: Colors.black87,
      child: Text(
        message,
        style: TextStyle(color: Colors.white),
        textAlign: TextAlign.center,
      ),
    );
  }
}
