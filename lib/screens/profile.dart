import 'dart:io';
import 'package:event_hub/screens/create_event_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_hub/models/event_card.dart'; // Proveri da li se fajl zove event_card.dart ili event_model.dart
import 'package:event_hub/widgets/event_card.dart';
import 'welcome_screen.dart';

class ProfileScreen extends StatefulWidget {
  final bool isGuest;
  const ProfileScreen({super.key, required this.isGuest});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  File? _image;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _nameController = TextEditingController();
  bool _isEditing = false;

  // Funkcija za biranje slike
  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        imageQuality: 85,
      );
      if (pickedFile != null) {
        setState(() => _image = File(pickedFile.path));
      }
    } catch (e) {
      debugPrint("Greška pri biranju slike: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final User? currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // 1. TOP BAR (Logo i Logout)
            _buildTopBar(),
            const SizedBox(height: 20),

            // 2. PROFIL HEADER (StreamBuilder za ime i sliku)
            _buildProfileHeader(currentUser),
            const SizedBox(height: 30),

            // 3. SEKCIJA: MOJI DOGAĐAJI (StreamBuilder za kreirane događaje)
            _buildSectionTitle("Moji događaji", showAdd: true),
            const SizedBox(height: 15),
            _buildMyEventsStream(currentUser),

            const SizedBox(height: 35),

            // 4. SEKCIJA: PRISUSTVUJEM (Statički placeholder za sada)
            _buildSectionTitle("Događaji kojima prisustvujem", showAdd: false),
            const SizedBox(height: 15),
            _buildEmptyState(
              "Lista događaja na koje ste se prijavili će se pojaviti ovde.",
            ),
          ],
        ),
      ),
    );
  }

  // --- WIDGET METODE ---

  Widget _buildTopBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const SizedBox(width: 40),
        Image.asset(
          'assets/logo2.png',
          height: 40,
          errorBuilder: (c, e, s) => const Icon(Icons.event),
        ),
        IconButton(
          icon: const Icon(Icons.logout, color: Colors.grey),
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
            if (mounted) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const WelcomeScreen()),
                (route) => false,
              );
            }
          },
        ),
      ],
    );
  }

  Widget _buildProfileHeader(User? currentUser) {
    if (widget.isGuest || currentUser == null) {
      return _buildEmptyState("Prijavite se da vidite profil.");
    }

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return const Center(child: CircularProgressIndicator());

        String name = "Korisnik";
        String surname = "";
        String email = currentUser.email ?? "";

        if (snapshot.hasData && snapshot.data!.exists) {
          var data = snapshot.data!.data() as Map<String, dynamic>;
          name = data['name'] ?? "";
          surname = data['surname'] ?? "";
          if (!_isEditing) _nameController.text = "$name $surname";
        }

        return Row(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey.shade200,
                    backgroundImage: _image != null
                        ? FileImage(_image!)
                        : const AssetImage('assets/avatar.png')
                              as ImageProvider,
                  ),
                  const CircleAvatar(
                    radius: 12,
                    backgroundColor: Color(0xFF2B8CBF),
                    child: Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 12,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _isEditing
                      ? TextField(
                          controller: _nameController,
                          decoration: const InputDecoration(isDense: true),
                        )
                      : Text(
                          "$name $surname",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                  Text(
                    email,
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(
                _isEditing ? Icons.check_circle : Icons.edit,
                color: const Color(0xFF2B8CBF),
              ),
              onPressed: () async {
                if (_isEditing) {
                  List<String> parts = _nameController.text.split(" ");
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(currentUser.uid)
                      .update({
                        'name': parts.isNotEmpty ? parts[0] : "",
                        'surname': parts.length > 1
                            ? parts.sublist(1).join(" ")
                            : "",
                      });
                }
                setState(() => _isEditing = !_isEditing);
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildMyEventsStream(User? user) {
    if (user == null) return const SizedBox();

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('events')
          .where('creatorId', isEqualTo: user.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return const Center(child: CircularProgressIndicator());
        final docs = snapshot.data!.docs;

        if (docs.isEmpty)
          return _buildEmptyState("Niste kreirali nijedan događaj.");

        return Column(
          children: [
            SizedBox(
              height: 220,
              child: PageView.builder(
                controller: _pageController,
                itemCount: docs.length,
                onPageChanged: (page) => setState(() => _currentPage = page),
                itemBuilder: (context, index) {
                  final data = docs[index].data() as Map<String, dynamic>;
                  final event = EventModel(
                    id: docs[index].id,
                    title: data['title'] ?? '',
                    category: data['category'] ?? '',
                    description: data['description'] ?? '',
                    date: data['date'] ?? '',
                    time: data['time'] ?? '',
                    location: data['location'] ?? '',
                    freeSpots: data['freeSpots'] ?? 0,
                    spots: data['spots'] ?? 0,
                    creatorId: data['creatorId'] ?? '',
                  );
                  return Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: EventCard(
                      event: event,
                      isGuest: widget.isGuest,
                      isAdmin: true,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            _buildPageIndicator(docs.length),
          ],
        );
      },
    );
  }

  Widget _buildSectionTitle(String title, {bool showAdd = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        if (showAdd)
          IconButton(
            icon: const Icon(
              Icons.add_circle_outline,
              color: Color(0xFF2B8CBF),
            ),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CreateEventScreen(),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildPageIndicator(int count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        count,
        (index) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: _currentPage == index ? 20 : 8,
          height: 8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: _currentPage == index
                ? const Color(0xFF2B8CBF)
                : Colors.grey.shade300,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(String msg) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(
        msg,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.grey),
      ),
    );
  }
}
