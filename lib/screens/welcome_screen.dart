import 'package:event_hub/screens/events_guest_screen.dart';
import 'package:event_hub/widgets/primaryBtn_widget.dart';

import 'package:event_hub/widgets/secondaryBtn_widget.dart';

import 'package:flutter/material.dart';
import '../widgets/guest_widget.dart';
import '../widgets/logo_widget.dart';
import 'login_screen.dart';
import 'register_screen.dart';

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
            //    const BackHeader(),
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LogoWidget(),
              const SizedBox(height: 150),
              PrimaryButton(
                text: 'Prijavi se',
                onPressed: () {
                  // Navigacija na LoginScreen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              SecondaryButton(
                text: 'Registruj se',
                onPressed: () {
                  // Navigacija na RegisterScreen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RegisterScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              GuestText1(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DiscoverEventsScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
