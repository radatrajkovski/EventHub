import 'package:event_hub/models/event_card.dart';
import 'package:event_hub/screens/event_details_screen.dart';
import 'package:flutter/material.dart';

class EventCard extends StatelessWidget {
  final EventModel event;
  final bool isGuest;
  final bool isAdmin;
  final VoidCallback? onTap;

  const EventCard({
    super.key,
    required this.event,
    required this.isGuest,
    this.isAdmin = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final int prijavljeno = event.spots - event.freeSpots;
    final double procenatPopunjenosti = event.spots > 0
        ? prijavljeno / event.spots
        : 0.0;
    return GestureDetector(
      onTap:
          onTap ??
          () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    EventDetailsScreen(event: event, isGuest: isGuest),
              ),
            );
          },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        // Glavni Row koji odvaja belu karticu od ikonica sa strane
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // BELA KARTICA
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFFD1E9F6),
                    width: 1.5,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Red sa naslovom i kategorijom
                    Row(
                      mainAxisAlignment: MainAxisAlignment
                          .spaceBetween, // Gura kategoriju DESNO
                      children: [
                        Expanded(
                          child: Text(
                            event.title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // KATEGORIJA (Sada je poravnata desno)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: event.getCategoryColor(event.category),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            event.category.toUpperCase(),
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _infoRow(Icons.calendar_today_outlined, event.date),
                    const SizedBox(height: 4),
                    _infoRow(Icons.location_on_outlined, event.location),

                    if (isAdmin) ...[
                      const Divider(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Popunjenost:",
                            style: TextStyle(fontSize: 11, color: Colors.grey),
                          ),
                          // DINAMIČKI ISPIS: npr. 17 / 30
                          Text(
                            "$prijavljeno / ${event.spots}",
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 6),
                      LinearProgressIndicator(
                        value:
                            procenatPopunjenosti, // Automatski pomera plavu traku
                        backgroundColor: Colors.grey[200],
                        color: const Color(0xFF2B8CBF),
                        minHeight: 6,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ] else ...[
                      const SizedBox(height: 8),
                      _infoRow(
                        Icons.people_outline,
                        "${event.freeSpots} slobodnih mesta",
                      ),
                    ],
                  ],
                ),
              ),
            ),

            // IKONICE DESNO (Van bele kartice - samo za Admina)
            if (isAdmin)
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      onPressed: () {
                        // Navigacija na Edit/Details ekran sa popunjenim podacima
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EventDetailsScreen(
                              event: event,
                              isGuest: isGuest,
                              isEditing:
                                  true, // Dodajemo ovaj flag da ekran zna da je u modu izmene
                            ),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.edit_outlined,
                        size: 22,
                        color: Colors.black54,
                      ),
                    ),
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      onPressed: () {},
                      icon: const Icon(
                        Icons.delete_outline,
                        size: 22,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.black87),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(fontSize: 13)),
      ],
    );
  }
}
