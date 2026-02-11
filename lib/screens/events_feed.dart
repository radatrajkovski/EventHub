import 'package:cloud_firestore/cloud_firestore.dart'; // DODAJ OVO
import 'package:event_hub/models/event_card.dart';
import 'package:event_hub/screens/login_screen.dart';
import 'package:event_hub/widgets/event_card.dart';
import 'package:flutter/material.dart';

class EventsFeedScreen extends StatelessWidget {
  final bool isGuest;

  const EventsFeedScreen({super.key, required this.isGuest});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Center(
                child: Image.asset(
                  'assets/logo2.png',
                  height: 40,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 35),
              const Text(
                "Otkrijte događaje",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),

              // SEARCH (Za sada samo UI)
              const TextField(
                decoration: InputDecoration(
                  hintText: "Pretražite događaje...",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              if (isGuest) _buildGuestBanner(context),

              const SizedBox(height: 20),

              // --- OVDE KREĆE MAGIJA: STREAMBUILDER UMESTO STATIČKE LISTE ---
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('events')
                    .orderBy('createdAt', descending: true) // Najnoviji prvi
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text("Greška pri učitavanju podataka"),
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  // Pretvaramo dokumente iz Firebase-a u tvoje EventModel objekte
                  final docs = snapshot.data!.docs;

                  if (docs.isEmpty) {
                    return const Center(
                      child: Text("Trenutno nema dostupnih događaja."),
                    );
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final data = docs[index].data() as Map<String, dynamic>;

                      // Kreiramo model iz podataka (bitno: prosleđujemo i ID dokumenta)
                      final event = EventModel(
                        id: docs[index].id,
                        title: data['title'] ?? '',
                        category: data['category'] ?? 'OSTALO',
                        description: data['description'] ?? '',
                        date: data['date'] ?? '',
                        time: data['time'] ?? '',
                        location: data['location'] ?? '',
                        freeSpots: data['freeSpots'] ?? 0,
                        spots: data['spots'] ?? 0,
                        creatorId: data['creatorId'] ?? '',
                        categoryColor: data['categoryColor'] != null
                            ? Color(int.parse(data['categoryColor']))
                            : const Color(0xFFF5F5F5), // Default boja
                      );

                      return EventCard(event: event, isGuest: isGuest);
                    },
                  );
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // Tvoj postojeći _buildGuestBanner ostaje isti...
  Widget _buildGuestBanner(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F9FF),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFFB3E5FC)),
      ),
      child: Column(
        children: [
          const Text(
            "Trenutno pregledate kao gost. Prijavite se kako biste mogli da se pridružite događajima.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF2B8CBF),
              fontSize: 13,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => LoginScreen()),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2B8CBF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                "Prijavi se",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
