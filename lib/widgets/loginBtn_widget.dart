import 'package:flutter/material.dart';

class AuthButton extends StatelessWidget {
  final String text;
  final bool isPrimary;

  const AuthButton({super.key, required this.text, required this.isPrimary});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 260,
      height: 48,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary
              ? const Color(0xFF2B8CBF)
              : Colors.transparent,
          foregroundColor: isPrimary ? Colors.white : const Color(0xFF2B8CBF),
          side: BorderSide(color: const Color(0xFF2B8CBF)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 0, // da ne bude senke kod transparentnog buttona
        ),
        onPressed: () {},
        child: Text(text),
      ),
    );
  }
}
