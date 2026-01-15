import 'package:flutter/material.dart';

class SearchTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final VoidCallback? onSearchTap;

  const SearchTextField({
    super.key,
    required this.hintText,
    this.controller,
    this.onSearchTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: const Icon(Icons.search, color: Color(0xFF2B8CBF)),
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
        onSubmitted: (_) {
          if (onSearchTap != null) onSearchTap!();
        },
      ),
    );
  }
}
