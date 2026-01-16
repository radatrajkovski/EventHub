import 'package:event_hub/models/event_card.dart';
import 'package:event_hub/widgets/searchTextField.dart';
import 'package:flutter/material.dart';

class EventCard extends StatelessWidget {
  final EventModel event;
  final VoidCallback? onTap;

  const EventCard({super.key, required this.event, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          // Tanki plavi okvir umesto senke, baš kao na dizajnu [cite: 13, 21, 65]
          border: Border.all(color: const Color(0xFFD1E9F6), width: 1.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    event.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(
                      0xFFEDEDED,
                    ), // Svetlo sivi badge [cite: 14, 66]
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    event.category,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              event.description,
              style: TextStyle(color: Colors.grey[700], height: 1.4),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            _iconRow(
              Icons.calendar_today_outlined,
              "${event.date} • ${event.time}",
            ),
            const SizedBox(height: 6),
            _iconRow(Icons.location_on_outlined, event.location),
            const SizedBox(height: 6),
            _iconRow(
              Icons.people_outline,
              "${event.freeSpots} slobodnih mesta",
            ),
          ],
        ),
      ),
    );
  }

  Widget _iconRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.black87),
        const SizedBox(width: 8),
        Expanded(child: Text(text, style: const TextStyle(fontSize: 13))),
      ],
    );
  }
}

class DiscoverEventsScreen extends StatelessWidget {
  DiscoverEventsScreen({super.key});

  // MOCK DATA: Lista sa različitim kategorijama za lepši vizuelni prikaz
  final List<EventModel> testEvents = [
    EventModel(
      title: "Tech Innovation Summit 2025",
      category: "TEHNOLOGIJA",
      description:
          "Lorem Ipsum je jednostavno model teksta koji se koristi u štamparskoj i slovoslagačkoj industriji.",
      date: "25. decembar 2025.",
      time: "18:00h",
      location: "Hubitat, Mite Ružića 2, Novi Sad",
      freeSpots: 13,
    ),
    EventModel(
      title: "Jazz Night Under the Stars",
      category: "MUZIKA",
      description:
          "Uživajte u zvucima saksofona i magičnoj atmosferi na krovu zgrade uz najbolje domaće džez muzičare.",
      date: "14. februar 2026.",
      time: "20:00h",
      location: "Promenada Rooftop, Novi Sad",
      freeSpots: 25,
    ),
    EventModel(
      title: "Design Thinking Radionica",
      category: "EDUKACIJA",
      description:
          "Naučite kako da rešavate probleme kreativno i kreirate proizvode koje korisnici zaista vole.",
      date: "03. mart 2026.",
      time: "10:00h",
      location: "Creative Hub, Beograd",
      freeSpots: 5,
    ),
  ];

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
              // LOGO
              Center(
                child: Image.asset(
                  'assets/logo2.png', // Putanja do tvoje slike
                  //height: 50, // Podesi visinu koja ti odgovara
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 35),
              const Text(
                "Otkrijte događaje", // [cite: 61]
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),

              // TVOJ SEARCH WIDGET
              const SearchTextField(hintText: "Pretražite događaje..."),

              const SizedBox(height: 25),

              // GUEST BANER [cite: 63, 64]
              _buildGuestBanner(),

              const SizedBox(height: 20),

              // LISTA KARTICA
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: testEvents.length,
                itemBuilder: (context, index) {
                  return EventCard(event: testEvents[index]);
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGuestBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F9FF), // Veoma svetlo plava [cite: 63]
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFFB3E5FC)),
      ),
      child: Column(
        children: [
          const Text(
            "Trenutno pregledate kao gost. Prijavite se kako biste mogli da se pridružite događajima.", // [cite: 63]
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
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2B8CBF), // [cite: 64]
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                "Prijavi se", // [cite: 64]
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
