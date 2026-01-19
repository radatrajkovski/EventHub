import 'package:flutter/material.dart';

class WeatherWidget extends StatelessWidget {
  const WeatherWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF6FB),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Vremenska prognoza",
                style: TextStyle(fontSize: 12, color: Color(0xFF2B8CBF)),
              ),
              SizedBox(height: 4),
              Text(
                "Delimično oblačno",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2B8CBF),
                ),
              ),
            ],
          ),
          Row(
            children: [
              const Icon(Icons.cloud_queue, color: Color(0xFF2B8CBF), size: 28),
              const SizedBox(width: 8),
              const Text(
                "22°C",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2B8CBF),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
