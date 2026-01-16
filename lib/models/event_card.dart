import 'package:flutter/material.dart';

class EventModel {
  final String title;
  final String category;
  final String description;
  final String date;
  final String time;
  final String location;
  final int freeSpots;

  EventModel({
    required this.title,
    required this.category,
    required this.description,
    required this.date,
    required this.time,
    required this.location,
    required this.freeSpots,
  });

  // Centralizovana lista kategorija
  static const List<String> kategorije = [
    'TEHNOLOGIJA',
    'MUZIKA',
    'UMETNOST',
    'SPORT',
    'EDUKACIJA',
    'BIZNIS',
  ];

  // Metoda koja vraća boju na osnovu kategorije
  Color getCategoryColor() {
    switch (category.toLowerCase()) {
      case 'tehnologija':
        return const Color(0xFFE0E0E0); // Siva kao na slici [cite: 14, 66]
      case 'muzika':
        return Colors.purple.shade100;
      case 'sport':
        return Colors.orange.shade100;
      default:
        return Colors.teal.shade100;
    }
  }
}
