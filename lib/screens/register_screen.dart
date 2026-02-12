import 'package:event_hub/widgets/backHeader_widget.dart';
import 'package:event_hub/widgets/customtTextField.dart';
import 'package:event_hub/widgets/passwordTextField.dart';
import 'package:event_hub/widgets/primaryBtn_widget.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Dodato
import 'package:cloud_firestore/cloud_firestore.dart'; // Dodato
import 'login_screen.dart';
import 'package:event_hub/screens/main_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  void _handleRegister() async {

    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'name': firstNameController.text.trim(),
        'surname': lastNameController.text.trim(),
        'email': emailController.text.trim(),
        'uid': userCredential.user!.uid,
      });
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const MainNavigationScreen(isGuest: false),
          ),
          (route) => false,
        );
      }
    } on FirebaseAuthException catch (e) {
      String message = "Došlo je do greške";
      if (e.code == 'weak-password') message = "Lozinka je previše slaba.";
      if (e.code == 'email-already-in-use') message = "Nalog sa ovim email-om već postoji.";
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } catch (e) {
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Pozadina
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/login.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            children: [
              const SizedBox(height: 24),
              const SafeArea(child: BackHeader()),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 24),
                        Image.asset('assets/logo1.png', width: 64, height: 64),
                        const SizedBox(height: 12),
                        const Text(
                          'Kreirajte nalog',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 64),

                        CustomTextField(
                          width: 320,
                          hintText: "Ime",
                          controller: firstNameController,
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          width: 320,
                          hintText: "Prezime",
                          controller: lastNameController,
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          width: 320,
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
                        _isLoading
                            ? const CircularProgressIndicator(color: Color(0xFF268AB2))
                            : PrimaryButton(
                                text: "Registrujte se",
                                onPressed: _handleRegister,
                              ),

                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Već imate nalog?',
                              style: TextStyle(fontSize: 12, color: Color(0xFF5A5959)),
                            ),
                            const SizedBox(width: 4),
                            GestureDetector(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const LoginScreen(),
                                ),
                              ),
                              child: const Text(
                                'Prijavite se',
                                style: TextStyle(
                                  color: Color(0xFF268AB2),
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
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
              ),
            ],
          ),
        ],
      ),
    );
  }
}