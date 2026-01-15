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
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const WelcomeScreen(),
                    ),
                  );
                },
                child: Row(
                  children: const [
                    Icon(Icons.arrow_back, color: Colors.black),
                    SizedBox(width: 4),
                    Text(
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
