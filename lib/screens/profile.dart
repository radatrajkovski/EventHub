import 'dart:io';
import 'package:event_hub/screens/create_event_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:event_hub/models/event_card.dart';
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
  final TextEditingController _nameController = TextEditingController(
    text: "Radmila Trajkovski",
  );
  bool _isEditing = false;

  final List<EventModel> mojiDogadjaji = [
    EventModel(
      id: "1",
      title: "Tech Innovation Summit 2025",
      category: "TEHNOLOGIJA",
      description: "Centralni događaj za nove tehnologije u regionu.",
      date: "25. decembar 2025.",
      time: "18:00h",
      location: "Hubitat, Novi Sad",
      freeSpots: 13,
      spots: 40,
    ),
    EventModel(
      id: "2",
      title: "Dizajn Radionica",
      category: "EDUKACIJA",
      description: "Naučite osnove UI/UX dizajna uz stručnjake.",
      date: "12. januar 2026.",
      time: "18:00h",
      location: "Poslovni Centar, Novi Sad",
      freeSpots: 5,
      spots: 30,
    ),
  ];

  final List<EventModel> pristvujem = [
    EventModel(
      id: "6",
      title: "Izložba: Digitalna Umetnost",
      category: "KULTURA",
      description:
          "Pogledajte kako veštačka inteligencija transformiše slikarstvo.",
      date: "12. april 2026.",
      time: "18:00h",
      location: "Galerija Matice srpske, Novi Sad",
      freeSpots: 30,
      spots: 60,
    ),
  ];

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
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 40),
                Image.asset(
                  'assets/logo2.png',
                  height: 40,
                  errorBuilder: (c, e, s) => const Icon(Icons.broken_image),
                ),
                IconButton(
                  icon: const Icon(Icons.logout, color: Colors.grey),
                  onPressed: () => Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const WelcomeScreen(),
                    ),
                    (route) => false,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Profil
            _buildProfileHeader(),
            const SizedBox(height: 30),

            // Moji događajis
            _buildSectionTitle("Moji događaji", showAdd: true),
            const SizedBox(height: 15),
            SizedBox(
              height:
                  220, 
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (int page) =>
                    setState(() => _currentPage = page),
                itemCount: mojiDogadjaji.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: EventCard(
                      event: mojiDogadjaji[index],
                      isGuest: widget.isGuest,
                      isAdmin:
                          true, 
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            _buildPageIndicator(),
            const SizedBox(height: 35),

            _buildSectionTitle("Događaji kojima prisustvujem", showAdd: false),
            const SizedBox(height: 15),
            ...pristvujem.map(
              (event) => Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: EventCard(
                  event: event,
                  isGuest: widget.isGuest,
                  isAdmin: false, 
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Row(
      children: [
        GestureDetector(
          onTap: _pickImage,
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey.shade200,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: _image != null
                      ? Image.file(_image!, fit: BoxFit.cover)
                      : Image.asset(
                          'assets/avatar.png',
                          fit: BoxFit.cover,
                          errorBuilder: (c, e, s) => const Icon(
                            Icons.person,
                            size: 40,
                            color: Colors.grey,
                          ),
                        ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Color(0xFF2B8CBF),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                  size: 14,
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
              if (_isEditing)
                SizedBox(
                  height: 30,
                  child: TextField(
                    controller: _nameController,
                    autofocus: true,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.zero,
                      isDense: true,
                      border: UnderlineInputBorder(),
                    ),
                  ),
                )
              else
                Text(
                  _nameController.text,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              const Text(
                "trajkovski.radmila@gmail.com",
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ],
          ),
        ),
        IconButton(
          icon: Icon(
            _isEditing ? Icons.check_circle : Icons.edit,
            color: const Color(0xFF2B8CBF),
          ),
          onPressed: () => setState(() => _isEditing = !_isEditing),
        ),
      ],
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
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CreateEventScreen(),
                ),
              );
            },
          ),
      ],
    );
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        mojiDogadjaji.length,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
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
}
