import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Event hub',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF268AB2)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Event hub'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // LOGO (otkomentariši kad dodaš asset)
            Image.asset('assets/logo.png', width: 140),
            const SizedBox(height: 30),

            const Text(
              'Aplikacija je trenutno u izradi.\n'
              'Molimo Vas da nas posetite kasnije!',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF268AB2), fontSize: 22),
            ),
          ],
        ),
      ),
    );
  }
}
