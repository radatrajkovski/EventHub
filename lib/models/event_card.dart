import 'dart:ui';

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
  final String creatorId; // UID korisnika koji je kreirao

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
    required this.creatorId,
  });

  // Metoda koja pretvara podatke iz baze u tvoj model
  factory EventModel.fromFirestore(
    Map<String, dynamic> data,
    String documentId,
  ) {
    return EventModel(
      id: documentId,
      title: data['title'] ?? '',
      category: data['category'] ?? 'OSTALO',
      description: data['description'] ?? '',
      date: data['date'] ?? '',
      time: data['time'] ?? '',
      location: data['location'] ?? '',
      freeSpots: data['freeSpots'] ?? 0,
      spots: data['spots'] ?? 0,
      creatorId: data['creatorId'] ?? '',
    );
  }

  Color getCategoryColor(String category) {
    final cat = category.toUpperCase();
    if (cat.contains('TEH')) return const Color(0xFFE3F2FD);
    if (cat.contains('MUZ')) return const Color(0xFFF3E5F5);
    if (cat.contains('SPO')) return const Color(0xFFFFF3E0);
    if (cat.contains('EDU')) return const Color(0xFFE8F5E9);
    return const Color(0xFFF5F5F5);
  }
}
