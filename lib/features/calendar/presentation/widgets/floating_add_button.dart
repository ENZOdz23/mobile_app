import 'package:flutter/material.dart';

class FloatingAddButton extends StatelessWidget {
  final VoidCallback onTap;

  const FloatingAddButton({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Colors.green,
      child: Icon(Icons.add),
      onPressed: onTap,
    );
  }
}
