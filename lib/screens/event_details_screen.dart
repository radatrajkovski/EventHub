import 'package:event_hub/models/event_card.dart';
import 'package:event_hub/widgets/backHeader_widget.dart';
import 'package:event_hub/widgets/event_details_widget.dart';
import 'package:event_hub/widgets/weather_widget.dart';

import 'package:flutter/material.dart';

class EventDetailsScreen extends StatelessWidget {
  final EventModel event;
  final bool isGuest;

  const EventDetailsScreen({
    super.key,
    required this.event,
    required this.isGuest,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // 1. Zaglavlje ostaje fiksno na vrhu
            const BackHeader(),

            // 2. Sve ostalo ide u Expanded skrol deo
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // KATEGORIJA
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: event.getCategoryColor(),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        event.category,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // NASLOV
                    Text(
                      event.title,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 25),

                    // INFO KARTICE
                    EventInfoTile(
                      icon: Icons.calendar_today_outlined,
                      label: "Datum",
                      value: event.date,
                    ),
                    EventInfoTile(
                      icon: Icons.access_time,
                      label: "Vreme",
                      value: event.time,
                    ),
                    EventInfoTile(
                      icon: Icons.location_on_outlined,
                      label: "Lokacija",
                      value: event.location,
                    ),
                    EventInfoTile(
                      icon: Icons.people_outline,
                      label: "Slobodna mesta",
                      value: "${event.freeSpots}",
                    ),

                    const SizedBox(height: 20),
                    const WeatherWidget(),
                    const SizedBox(height: 25),

                    // OPIS
                    const Text(
                      "O događaju",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      event.description,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black87,
                        height: 1.5,
                      ),
                    ),

                    // 3. DUGME SADA IDE OVDE (Na kraj Column-a)
                    const SizedBox(height: 40), // Razmak iznad dugmeta
                    ElevatedButton(
                      onPressed: isGuest
                          ? null
                          : () {
                              // Logika za prijavu
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2B8CBF),
                        disabledBackgroundColor: Colors.grey[300],
                        minimumSize: const Size(double.infinity, 54),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        isGuest
                            ? "Ulogujte se da se pridružite"
                            : "Pridruži se događaju",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ), // Razmak ispod dugmeta da ne "udara" u ivicu ekrana
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
