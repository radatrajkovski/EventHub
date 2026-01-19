import 'package:event_hub/models/event_card.dart';
import 'package:event_hub/screens/event_details_screen.dart';
import 'package:event_hub/widgets/event_card.dart';
import 'package:flutter/material.dart';

class EventsFeedScreen extends StatelessWidget {
  final bool isGuest;

  EventsFeedScreen({super.key, required this.isGuest});

  // Tvoja lista podataka
  final List<EventModel> testEvents = [
    EventModel(
      title: "Tech Innovation Summit 2025",
      category: "TEHNOLOGIJA",
      description:
          "Ovo je izuzetno dugačak opis koji služi da testiramo kako aplikacija rukuje sa velikom količinom informacija. Tech Innovation Summit 2025 predstavlja centralni događaj za sve ljubitelje novih tehnologija u regionu. Očekuju vas predavanja svetski poznatih govornika iz kompanija kao što su Google, Microsoft i NVIDIA. Pričaćemo o veštačkoj inteligenciji, budućnosti robotike i kako blockchain menja ekonomiju. Pored predavanja, imaćete priliku da učestvujete u praktičnim radionicama gde ćete moći da testirate najnovije VR setove i vidite kako funkcionišu kvantni računari uživo. Obezbeđen je ručak, kafa i osveženje za sve posetioce, kao i sertifikat o učešću na kraju dana. Vidimo se u Novom Sadu!",
      date: "25. decembar 2025.",
      time: "18:00h",
      location: "Hubitat, Mite Ružića 2, Novi Sad",
      freeSpots: 13,
    ),
    EventModel(
      title: "Kreativna radionica dizajna",
      category: "EDUKACIJA",
      description:
          "Pridružite nam se na trosatnoj intenzivnoj radionici gde ćemo prolaziti kroz osnove UI/UX dizajna. Naučićete kako da koristite Figmu kao profesionalac, kako da birate palete boja koje privlače korisnike i kako da kreirate prototip koji oduševljava klijente. Radionica je namenjena početnicima, ali i onima koji žele da usavrše svoje veštine. Potrebno je poneti sopstveni laptop i dobru energiju. Broj mesta je strogo ograničen kako bismo svakom učesniku posvetili dovoljno pažnje i pomogli mu u izradi njegovog prvog portfolia.",
      date: "10. januar 2026.",
      time: "12:00h",
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
                child: Image.asset('assets/logo2.png', fit: BoxFit.contain),
              ),
              const SizedBox(height: 35),
              const Text(
                "Otkrijte događaje",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),

              // SEARCH (Ovde koristiš tvoj SearchTextField widget)
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

              // BANER ZA GOSTA (Pojavljuje se samo ako je isGuest true)
              if (isGuest) _buildGuestBanner(context),

              const SizedBox(height: 20),

              // LISTA KARTICA
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: testEvents.length,
                itemBuilder: (context, index) {
                  return EventCard(
                    event: testEvents[index],
                    onTap: () {
                      // KLJUČNI DEO: Otvaranje detalja
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EventDetailsScreen(
                            event: testEvents[index],
                            isGuest: isGuest,
                          ),
                        ),
                      );
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
                // Ovde možeš dodati navigaciju na Login ako ga imaš
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
