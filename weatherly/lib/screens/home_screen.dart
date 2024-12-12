import 'package:flutter/material.dart';
import 'weather_alerts_screen.dart';
import 'detailed_forecast_screen.dart';
import 'customizable_backgrounds_screen.dart';
import 'interactive_maps_screen.dart';
import 'community_insights_screen.dart';
import 'package:geolocator/geolocator.dart';
import '../services/weather_service.dart'; // Import your WeatherService class

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _currentWeather = 'Loading...';
  bool _loading = true;

  // Fetch current weather
  Future<void> _fetchWeather() async {
    setState(() {
      _loading = true;
    });

    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      final weatherData = await WeatherService.fetchWeatherByCoordinates(position.latitude, position.longitude);

      setState(() {
        _currentWeather = 'Current Weather: ${weatherData['main']['temp']}°C, ${weatherData['weather'][0]['description']}';
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _currentWeather = 'Failed to fetch weather.';
        _loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Weatherly Dashboard')),
      ),
      body: Center(
        child: _loading
            ? const CircularProgressIndicator()
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                _currentWeather,
                style: const TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2, // Split into two sides
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                padding: const EdgeInsets.all(16.0),
                children: [
                  _buildButton(context, 'Weather Alerts', const WeatherAlertsScreen()),
                  _buildButton(context, 'Detailed Forecast', DetailedForecastScreen()),
                  _buildButton(context, 'Custom Backgrounds', const CustomizableBackgroundsScreen()),
                  _buildButton(context, 'Interactive Maps', const InteractiveMapsScreen()),
                  _buildButton(context, 'Community Insights', const CommunityInsightsScreen()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, String title, Widget screen) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // Slightly rounded corners
        ),
        backgroundColor: Colors.blueAccent, // Consistent background color
      ),
      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => screen)),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }
}
