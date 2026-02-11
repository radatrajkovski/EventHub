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
  final String creatorId;
  final Color categoryColor; // DODAJ OVO POLJE

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
    required this.categoryColor, // DODAJ OVO U KONSTRUKTOR
  });

  factory EventModel.fromFirestore(
    Map<String, dynamic> data,
    String documentId,
  ) {
    // Funkcija koja pretvara String iz baze u boju
    Color parseColor(String? hexString) {
      if (hexString == null) return const Color(0xFFF5F5F5);
      return Color(int.parse(hexString));
    }

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
      categoryColor: parseColor(data['categoryColor']), // Uzimamo boju iz baze
    );
  }
}
