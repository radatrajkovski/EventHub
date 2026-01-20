import 'package:event_hub/models/event_card.dart';
import 'package:flutter/material.dart';

import '../widgets/event_card.dart';

//OVO SE NIGDE NE KORISTI
class HomeScreen extends StatelessWidget {
  final bool isGuest;
  HomeScreen({super.key, required this.isGuest}); 

  final List<EventModel> events = [
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
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Svi događaji")),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: events.length,
        itemBuilder: (context, index) {
          return EventCard(
            event: events[index],
            onTap: () {
              // kasnije: navigacija ka Event Details
            },
            isGuest: isGuest,
          );
        },
      ),
    );
  }
}
