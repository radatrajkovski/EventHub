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
}
