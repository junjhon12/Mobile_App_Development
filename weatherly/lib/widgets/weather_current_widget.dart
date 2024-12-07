import 'package:flutter/material.dart';
import '../services/weather_service.dart';

class WeatherCurrentWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: WeatherService().getWeatherByLocation(37.7749, -122.4194), // Example: San Francisco
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error loading weather data'));
        }
        final weatherData = snapshot.data as Map<String, dynamic>;
        return Card(
          child: Column(
            children: [
              Text(
                '${weatherData['name']}',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text('${weatherData['weather'][0]['description']}'),
              Text('Temperature: ${weatherData['main']['temp']}°C'),
            ],
          ),
        );
      },
    );
  }
}
