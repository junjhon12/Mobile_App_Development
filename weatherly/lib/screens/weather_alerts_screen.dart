import 'package:flutter/material.dart';
import '../services/weather_service.dart';

class WeatherAlertsScreen extends StatefulWidget {
  const WeatherAlertsScreen({super.key});

  @override
  State<WeatherAlertsScreen> createState() => _WeatherAlertsScreenState();
}

class _WeatherAlertsScreenState extends State<WeatherAlertsScreen> {
  String weatherInfo = 'Fetching weather data...';

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  Future<void> _fetchWeather() async {
    try {
      // Replace "YourCityName" with a valid city name or a variable from user input
      final weatherData = await WeatherService.fetchWeather('YourCityName');
      setState(() {
        weatherInfo = 'Temperature: ${weatherData['main']['temp']}°C\n'
                      'Condition: ${weatherData['weather'][0]['description']}';
      });
    } catch (e) {
      setState(() {
        weatherInfo = 'Failed to fetch weather data. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Weather Alerts')),
      body: Center(
        child: Text(
          weatherInfo,
          style: const TextStyle(fontSize: 16),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
