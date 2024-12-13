import 'package:flutter/material.dart';
import '../services/weather_service.dart';

class WeatherCurrentWidget extends StatelessWidget {
  const WeatherCurrentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: WeatherService.fetchWeatherByCoordinates(37.7749, -122.4194), // Example: San Francisco
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Center(child: Text('Error loading weather data'));
        }
        if (snapshot.hasData) {
          final weatherData = snapshot.data as Map<String, dynamic>;
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${weatherData['name']}',
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text('${weatherData['weather'][0]['description']}'),
                  const SizedBox(height: 8),
                  Text('Temperature: ${weatherData['main']['temp']}°C'),
                ],
              ),
            ),
          );
        }
        return const Center(child: Text('No weather data available.'));
      },
    );
  }
}
