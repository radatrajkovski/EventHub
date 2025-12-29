import 'package:flutter/material.dart';

class LogoWidget extends StatelessWidget {
  const LogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset('assets/logo.png', height: 220),
        const SizedBox(height: 24),
        const Text(
          'Otkrijte i napravite neverovatne \n događaje u svojoj zajednici',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, color: Colors.black87),
        ),
      ],
    );
  }
}
