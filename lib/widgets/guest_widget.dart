import 'package:flutter/material.dart';

class GuestText1 extends StatelessWidget {
  final VoidCallback onTap; // Dodajemo ovo
  const GuestText1({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap  ,
      child: const Text(
        'Nastavi kao gost',
        style: TextStyle(
          color: Color(0xFF2B8CBF),
          //decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}
