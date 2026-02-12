import 'package:flutter/material.dart';

class WeatherWidget extends StatelessWidget {
  final int temp;
  final String description;
  final String iconCode;

  const WeatherWidget({
    super.key,
    required this.temp,
    required this.description,
    required this.iconCode,
  });

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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Vremenska prognoza",
                style: TextStyle(fontSize: 12, color: Color(0xFF2B8CBF)),
              ),
              const SizedBox(height: 4),
              Text(
                description[0].toUpperCase() + description.substring(1),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2B8CBF),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Image.network(
                "https://openweathermap.org/img/wn/$iconCode@2x.png",
                width: 40,
              ),
              const SizedBox(width: 8),
              Text(
                "$temp°C",
                style: const TextStyle(
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
