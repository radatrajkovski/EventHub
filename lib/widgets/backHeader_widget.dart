import 'package:flutter/material.dart';
import '../screens/welcome_screen.dart';

class BackHeader extends StatelessWidget {
  const BackHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  // Proveravamo da li uopšte postoji ekran na koji možemo da se vratimo
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                },
                child: Row(
                  children: [
                    const Icon(Icons.arrow_back, color: Colors.black),
                    const SizedBox(width: 4),
                    const Text(
                      "Nazad",
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Divider(
          color: const Color(0xFF268AB2).withOpacity(0.1),
          thickness: 1,
          height: 0,
        ),
      ],
    );
  }
}
