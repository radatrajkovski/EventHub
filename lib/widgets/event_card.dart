import 'package:event_hub/models/event_card.dart';
import 'package:flutter/material.dart';

class EventCard extends StatelessWidget {
  final EventModel event;
  final VoidCallback? onTap;

  const EventCard({super.key, required this.event, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title + Category
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.teal.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      event.category,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Description
              Text(
                event.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 12),

              // Date & Time
              Row(
                children: [
                  const Icon(Icons.calendar_today, size: 16),
                  const SizedBox(width: 6),
                  Text("${event.date} • ${event.time}"),
                ],
              ),

              const SizedBox(height: 6),

              // Location
              Row(
                children: [
                  const Icon(Icons.location_on, size: 16),
                  const SizedBox(width: 6),
                  Expanded(child: Text(event.location)),
                ],
              ),

              const SizedBox(height: 6),

              // Free spots
              Text(
                "${event.freeSpots} slobodnih mesta",
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
