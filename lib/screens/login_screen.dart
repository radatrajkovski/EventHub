import 'package:event_hub/widgets/backHeader_widget.dart';
import 'package:event_hub/widgets/customtTextField.dart';
import 'package:event_hub/widgets/passwordTextField.dart';
import 'package:event_hub/widgets/primaryBtn_widget.dart';
import 'package:event_hub/widgets/secondaryBtn_widget.dart';
import 'package:flutter/material.dart';
import '../widgets/guest_widget.dart';
import 'register_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Scaffold(
      body: Stack(
        children: [
          // Pozadinska slika
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/login.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Sadržaj ekrana
          Column(
            children: [
              // BackHeader zalepljen za vrh
              const SizedBox(height: 24),
              const SafeArea(child: BackHeader()),

              // Scrollable sadržaj ispod strelice
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 24,
                      ), // malo prostora ispod strelice
                      Image.asset('assets/logo1.png', width: 64, height: 64),
                      const SizedBox(height: 12),
                      const Text(
                        'Dobrodošli nazad',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 32,
                          fontWeight: FontWeight.normal,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Prijavite se na vaš nalog',
                        style: TextStyle(
                          color: Color(0xFF5A5959),
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      const SizedBox(height: 64),
                      CustomTextField(
                        hintText: "Email",
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 16),
                      PasswordTextField(
                        hintText: "Lozinka",
                        controller: passwordController,
                      ),
                      const SizedBox(height: 24),
                      PrimaryButton(
                        text: "Prijavi se",
                        onPressed: () {
                          print(
                            "Login dugme kliknuto: ${emailController.text}",
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Još uvek nemate nalog?',
                            style: TextStyle(
                              color: Color(0xFF5A5959),
                              fontSize: 12,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          const SizedBox(width: 4),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => RegisterScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              'Registrujte se',
                              style: TextStyle(
                                color: Color(0xFF268AB2),
                                fontSize: 12,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
