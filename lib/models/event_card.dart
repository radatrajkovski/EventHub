import 'package:flutter/material.dart';

class EventModel {
  final String id;
  final String title;
  final String category;
  final String description;
  final String date;
  final String time;
  final String location;
  final int freeSpots;
  final int spots;
  final String organizerName;

  EventModel({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.date,
    required this.time,
    required this.location,
    required this.freeSpots,
    required this.spots,
    this.organizerName = "Radmila Trajkovski",
  });


  static const List<String> kategorije = [
    'TEHNOLOGIJA',
    'MUZIKA',
    'UMETNOST',
    'SPORT',
    'EDUKACIJA',
    'BIZNIS',
  ];

  Color getCategoryColor(String category) {
    final cat = category.toUpperCase();

    if (cat.contains('TEH')) return const Color(0xFFE3F2FD);
    if (cat.contains('MUZ')) return const Color(0xFFF3E5F5);
    if (cat.contains('SPO')) return const Color(0xFFFFF3E0);
    if (cat.contains('EDU')) return const Color(0xFFE8F5E9);
    if (cat.contains('HRA')) return const Color(0xFFFFEBEE);
    if (cat.contains('ZDR')) return const Color(0xFFE0F2F1);
    if (cat.contains('KUL')) return const Color(0xFFFFFDE7);
    if (cat.contains('BIZ')) return const Color(0xFFECEFF1);
    return const Color(0xFFF5F5F5);
  }
}
