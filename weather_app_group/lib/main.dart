import 'package:flutter/material.dart';
import 'firebase_services.dart';
import 'weather_api_service.dart';
import 'background_selector.dart';
import 'preferences_service.dart';
import 'interactive_map.dart';
import 'community_page.dart';

void main() {
  runApp(const WeatherlyApp());
}

class WeatherlyApp extends StatelessWidget {
  const WeatherlyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WeatherHomePage(),
    );
  }
}

class WeatherHomePage extends StatefulWidget {
  const WeatherHomePage({super.key});

  @override
  _WeatherHomePageState createState() => _WeatherHomePageState();
}

class _WeatherHomePageState extends State<WeatherHomePage> {
  String cityName = '';
  String weatherBackground = 'sunny'; // Default background theme

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Weatherly')),
      ),
      body: Column(
        children: [
          BackgroundSelector(theme: weatherBackground),
          const SizedBox(height: 10),
          TextField(
            onChanged: (value) => setState(() {
              cityName = value;
            }),
            decoration: InputDecoration(
              hintText: 'Enter city name',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              final weather = await WeatherApiService.fetchCurrentWeather(cityName);
              if (weather['main']['temp'] > 25) {
                setState(() => weatherBackground = 'sunny');
              } else {
                setState(() => weatherBackground = 'cloudy');
              }
            },
            child: const Text('Fetch Weather'),
          ),
          ElevatedButton(
            onPressed: () {
              // Navigate to community page to report weather
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CommunityPage()),
              );
            },
            child: const Text('Community Insights'),
          ),
        ],
      ),
    );
  }
}
