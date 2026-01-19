import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  final bool isGuest;
  const ProfileScreen({super.key, required this.isGuest});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // LOGO I PROFILNA (Gornji deo)
            Center(child: Image.asset('assets/logo2.png', height: 40)),
            const SizedBox(height: 30),
            _buildProfileHeader(),
            const SizedBox(height: 30),

            // SEKCIJA: MOJI DOGAĐAJI (Horizontalni skrol)
            _buildSectionTitle("Moji događaji", showAdd: true),
            const SizedBox(height: 15),
            SizedBox(
              height: 180, // Visina kartice
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (int page) =>
                    setState(() => _currentPage = page),
                itemCount: 3, // Broj tvojih događaja
                itemBuilder: (context, index) => _buildMyEventCard(),
              ),
            ),
            const SizedBox(height: 10),
            _buildPageIndicator(), // Tačkice

            const SizedBox(height: 30),

            // SEKCIJA: DOGAĐAJI KOJIMA PRISUSTVUJEM
            _buildSectionTitle("Događaji kojima prisustvujem", showAdd: false),
            const SizedBox(height: 15),
            // Ovde idu obične kartice jedna ispod druge
            _buildAttendingEventCard(),
            _buildAttendingEventCard(),
          ],
        ),
      ),
    );
  }

  // Pomoćni vidžet za tačkice (Dots Indicator)
  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _currentPage == index
                ? const Color(0xFF2B8CBF)
                : Colors.blue.withOpacity(0.2),
          ),
        );
      }),
    );
  }

  Widget _buildProfileHeader() {
    return Row(
      children: [
        const CircleAvatar(
          radius: 35,
          backgroundImage: AssetImage('assets/avatar.png'), // Stavi neku sliku
        ),
        const SizedBox(width: 15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "Radmila Trajkovski",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              "trajkovski.radmila@gmail.com",
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ],
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
        if (showAdd) const Icon(Icons.add, color: Colors.black),
      ],
    );
  }

  // Kartica za horizontalni skrol (sa Edit/Delete ikonicama)
  Widget _buildMyEventCard() {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.blue.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Text(
                  "Tech Innovation Summit 2025",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Row(
                children: const [
                  Icon(Icons.edit_outlined, size: 18),
                  SizedBox(width: 10),
                  Icon(Icons.delete_outline, size: 18),
                ],
              ),
            ],
          ),
          const SizedBox(height: 15),
          _iconText(Icons.calendar_today, "25. decembar 2025."),
          _iconText(
            Icons.location_on_outlined,
            "Hubitat, Mite Ružića 2, Novi Sad",
          ),
          _iconText(Icons.people_outline, "13 slobodnih mesta"),
        ],
      ),
    );
  }

  // Kartica za donju listu (sa "Tehnologija" tagom)
  Widget _buildAttendingEventCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.blue.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Tech Innovation Summit 2025",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: const Text(
                  "TEHNOLOGIJA",
                  style: TextStyle(fontSize: 10, color: Colors.grey),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            "Lorem Ipsum je jednostavno model teksta koji se koristi...",
            maxLines: 2,
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 12),
          _iconText(Icons.calendar_today, "25. decembar 2025."),
          _iconText(
            Icons.location_on_outlined,
            "Hubitat, Mite Ružića 2, Novi Sad",
          ),
        ],
      ),
    );
  }

  Widget _iconText(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        children: [
          Icon(icon, size: 14, color: Colors.grey),
          const SizedBox(width: 8),
          Text(text, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }
}
