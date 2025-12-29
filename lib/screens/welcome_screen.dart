import 'package:event_hub/widgets/loginBtn_widget.dart';
import 'package:flutter/material.dart';
import '../widgets/guest_widget.dart';
import '../widgets/logo_widget.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/pozadina.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LogoWidget(),
              SizedBox(height: 150),
              AuthButton(text: 'Prijavi se', isPrimary: true),
              SizedBox(height: 16),
              AuthButton(text: 'Registruj se', isPrimary: false),
              SizedBox(height: 16),
              GuestText1(),
            ],
          ),
        ),
      ),
    );
  }
}
