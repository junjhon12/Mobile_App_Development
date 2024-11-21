import 'package:flutter/material.dart';

class ShareWeatherCard extends StatelessWidget {
  final String city;
  final String temperature;

  const ShareWeatherCard({required this.city, required this.temperature});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Text(city, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          Text('$temperature°C', style: TextStyle(fontSize: 20)),
        ],
      ),
    );
  }
}
