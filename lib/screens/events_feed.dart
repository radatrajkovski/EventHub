import 'package:event_hub/models/event_card.dart';
import 'package:event_hub/screens/login_screen.dart';
import 'package:event_hub/widgets/event_card.dart';
import 'package:flutter/material.dart';

class EventsFeedScreen extends StatelessWidget {
  final bool isGuest;

  EventsFeedScreen({super.key, required this.isGuest});
  final List<EventModel> testEvents = [
    EventModel(
      id: "1",
      title: "Tech Innovation Summit 2025",
      category: "TEHNOLOGIJA",
      description:
          "Ovo je izuzetno dugačak opis koji služi da testiramo kako aplikacija rukuje sa velikom količinom informacija. Tech Innovation Summit 2025 predstavlja centralni događaj za sve ljubitelje novih tehnologija u regionu.",
      date: "25. decembar 2025.",
      time: "18:00h",
      location: "Hubitat, Mite Ružića 2, Novi Sad",
      freeSpots: 13,
      spots: 30,
    ),
    EventModel(
      id: "1",
      title: "Kreativna radionica dizajna",
      category: "EDUKACIJA",
      description:
          "Pridružite nam se na trosatnoj intenzivnoj radionici gde ćemo prolaziti kroz osnove UI/UX dizajna.",
      date: "10. januar 2026.",
      time: "12:00h",
      location: "Creative Hub, Beograd",
      freeSpots: 5,
      spots: 30,
    ),
    EventModel(
      id: "3",
      title: "Gastro Fest: Ukusi Balkana",
      category: "HRANA",
      description:
          "Pridružite nam se na najvećem festivalu hrane! Degustacije vrhunskih specijaliteta, radionice sa poznatim kuvarima i muzički program uživo.",
      date: "15. mart 2026.",
      time: "14:00h",
      location: "Limanski park, Novi Sad",
      freeSpots: 50,
      spots: 60,
    ),

    EventModel(
      id: "4",
      title: "Yoga & Mindfulness Jutro",
      category: "ZDRAVLJE",
      description:
          "Započnite vikend uz vođenu meditaciju i jogu na otvorenom. Pogodno za sve nivoe, ponesite prostirku i osmeh.",
      date: "22. mart 2026.",
      time: "08:30h",
      location: "Ada Ciganlija, Beograd",
      freeSpots: 20,
      spots: 30,
    ),

    EventModel(
      id: "5",
      title: "Startup Networking Night",
      category: "BIZNIS",
      description:
          "Upoznajte investitore i mlade preduzetnike. Kratke prezentacije ideja uz opuštenu atmosferu i networking.",
      date: "05. april 2026.",
      time: "19:00h",
      location: "Science Tech Park, Beograd",
      freeSpots: 45,
      spots: 80,
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
      spots: 45,
    ),

    EventModel(
      id: "7",
      title: "Planinarski uspon na Frušku Goru",
      category: "SPORT",
      description:
          "Zajednička šetnja stazama zdravlja. Obavezna udobna obuća i flašica vode. Dužina staze je 12km.",
      date: "19. april 2026.",
      time: "09:00h",
      location: "Popovica, Fruška Gora",
      freeSpots: 15,
      spots: 30,
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

              // SEARCH
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

              // BANER ZA GOSTA
              if (isGuest) _buildGuestBanner(context),

              const SizedBox(height: 20),

              // LISTA KARTICA
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: testEvents.length,
                itemBuilder: (context, index) {
                  return EventCard(event: testEvents[index], isGuest: isGuest);
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

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
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => LoginScreen()),
                );
              },
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
