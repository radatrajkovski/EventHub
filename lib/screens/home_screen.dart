import 'package:event_hub/models/event_card.dart';
import 'package:flutter/material.dart';

import '../widgets/event_card.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final List<EventModel> events = [
    EventModel(
      title: "Tech Innovation Summit 2025",
      category: "Tehnologija",
      description:
          "Lorem Ipsum je jednostavno model teksta koji se koristi u štamparskoj i slovoslagačkoj industriji.",
      date: "25. decembar 2025.",
      time: "18:00h",
      location: "Hubitat, Mite Ružića 2, Novi Sad",
      freeSpots: 13,
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
          );
        },
      ),
    );
  }
}
