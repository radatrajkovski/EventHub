import 'package:flutter/material.dart';

class EventModel {
  final String title;
  final String category;
  final String description;
  final String date;
  final String time;
  final String location;
  final int freeSpots;
  final String organizerName; // Dodato za detalje ekrana

  EventModel({
    required this.title,
    required this.category,
    required this.description,
    required this.date,
    required this.time,
    required this.location,
    required this.freeSpots,
    this.organizerName = "Radmila Trajkovski",
  });

  // Centralizovana lista
  static const List<String> kategorije = [
    'TEHNOLOGIJA',
    'MUZIKA',
    'UMETNOST',
    'SPORT',
    'EDUKACIJA',
    'BIZNIS',
  ];

  // Poboljšana metoda za boju - sada je otporna na velika/mala slova
  Color getCategoryColor() {
    final cat = category.toUpperCase(); // Standardizujemo na velika slova
    if (cat.contains('TEH')) return const Color(0xFFF1F1F1);
    if (cat.contains('MUZ')) return Colors.purple.shade50;
    if (cat.contains('SPO')) return Colors.orange.shade50;
    if (cat.contains('EDU')) return Colors.teal.shade50;
    return const Color(0xFFF1F1F1); // Default siva sa slike
  }
}
