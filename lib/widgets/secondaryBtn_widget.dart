import 'package:flutter/material.dart';

class SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  const SecondaryButton({super.key, required this.text, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 260,
      height: 48,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFF2B8CBF),
          side: const BorderSide(color: Color(0xFF2B8CBF)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: onPressed,
        child: Text(text),
      ),
    );
  }
}
