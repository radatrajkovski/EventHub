import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final TextInputType keyboardType;

  const CustomTextField({
    super.key,
    required this.hintText,
    this.controller,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 321,
      height: 48,
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hintText,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFF2B8CBF)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFF2B8CBF), width: 2),
          ),
        ),
      ),
    );
  }
}
