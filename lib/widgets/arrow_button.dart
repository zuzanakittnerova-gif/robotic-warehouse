import 'package:flutter/material.dart';

class ArrowButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const ArrowButton({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 72,
      height: 56,
      child: FilledButton(
        onPressed: onPressed,
        child: Icon(icon, size: 30),
      ),
    );
  }
}
