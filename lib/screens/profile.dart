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

  // --- PODACI ZA FRONTEND PREZENTACIJU ---
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
    EventModel(
      id: "6",
      title: "Izložba: Digitalna Umetnost",
      category: "KULTURA",
      description:
          "Pogledajte kako veštačka inteligencija i digitalni alati transformišu klasično slikarstvo. Radovi lokalnih umetnika.",
      date: "12. april 2026.",
      time: "18:00h",
      location: "Galerija Matice srpske, Novi Sad",
      freeSpots: 30,
      spots: 60,
    ),
  ];
  final List<EventModel> pristvujem = [
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
    EventModel(
      id: "6",
      title: "Izložba: Digitalna Umetnost",
      category: "KULTURA",
      description:
          "Pogledajte kako veštačka inteligencija i digitalni alati transformišu klasično slikarstvo. Radovi lokalnih umetnika.",
      date: "12. april 2026.",
      time: "18:00h",
      location: "Galerija Matice srpske, Novi Sad",
      freeSpots: 30,
      spots: 60,
    ),
  ];
  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() => _image = File(pickedFile.path));
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
            // LOGO I LOGOUT
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 40),
                Image.asset('assets/logo2.png', height: 40),
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

            // PROFILNI DEO
            _buildProfileHeader(),
            const SizedBox(height: 30),

            // SEKCIJA 1: MOJI DOGAĐAJI (GDE SAM JA ADMIN)
            _buildSectionTitle("Moji događaji", showAdd: true),
            const SizedBox(height: 15),
            SizedBox(
              height: 290,
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
                      isAdmin: true, // Ovo pali ikonice i progress bar
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            _buildPageIndicator(),
            const SizedBox(height: 35),

            // SEKCIJA 2: DOGAĐAJI KOJIMA PRISUSTVUJEM (GDE SAM GOST)
            _buildSectionTitle("Događaji kojima prisustvujem", showAdd: false),
            const SizedBox(height: 15),

            // Ovde ređamo obične kartice jednu ispod druge
            ...pristvujem.map(
              (event) => EventCard(
                event: event,
                isGuest: widget.isGuest,
                isAdmin: false, // Običan izgled bez ikonica
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
              CircleAvatar(
                radius: 40,
                backgroundColor: Colors.grey.shade200,
                backgroundImage: _image != null
                    ? FileImage(_image!)
                    : const AssetImage('assets/avatar.png') as ImageProvider,
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
                TextField(
                  controller: _nameController,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: const InputDecoration(isDense: true),
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
          width: _currentPage == index ? 20 : 8, // Efekat aktivne stranice
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
