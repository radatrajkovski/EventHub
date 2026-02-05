import 'package:event_hub/screens/create_event_screen.dart';
import 'package:event_hub/screens/events_feed.dart';
import 'package:event_hub/screens/profile.dart';
import 'package:flutter/material.dart';

class MainNavigationScreen extends StatefulWidget {
  final bool isGuest;
  const MainNavigationScreen({super.key, required this.isGuest});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  // Lista ekrana
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      EventsFeedScreen(isGuest: widget.isGuest),
      const CreateEventScreen(),
      ProfileScreen(isGuest: widget.isGuest),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        selectedItemColor: const Color(0xFF2B8CBF),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Feed'),
          BottomNavigationBarItem(icon: Icon(Icons.add_box), label: 'Kreiraj'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],  
      ),
    );
  }
}
