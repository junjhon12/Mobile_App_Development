import 'package:flutter/material.dart';

class WeatherHourlyForecast extends StatelessWidget {
  const WeatherHourlyForecast({super.key});

  @override
  Widget build(BuildContext context) {
    // Placeholder for hourly data
    return const Card(
      child: Column(
        children: [
          Text('Hourly Forecast', style: TextStyle(fontSize: 18)),
          ListTile(title: Text('1 PM: Sunny, 22°C')),
          ListTile(title: Text('2 PM: Cloudy, 21°C')),
        ],
      ),
    );
  }
}

class WeatherWeeklyForecast extends StatelessWidget {
  const WeatherWeeklyForecast({super.key});

  @override
  Widget build(BuildContext context) {
    // Placeholder for weekly data
    return const Card(
      child: Column(
        children: [
          Text('7-Day Forecast', style: TextStyle(fontSize: 18)),
          ListTile(title: Text('Monday: Rain, 18°C')),
          ListTile(title: Text('Tuesday: Cloudy, 20°C')),
        ],
      ),
    );
  }
}
