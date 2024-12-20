import 'package:flutter/material.dart';
import 'weather_alerts_screen.dart';
import 'detailed_forecast_screen.dart';
import 'customizable_backgrounds_screen.dart';
import 'interactive_maps_screen.dart';
import 'community_insights_screen.dart';
import 'package:geolocator/geolocator.dart';
import '../services/weather_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _currentWeather = 'Loading...';
  String _currentDay = '';
  String _currentDate = '';
  String _currentTemperature = '';
  String _weatherIconUrl = '';
  bool _loading = true;

  Future<void> _fetchWeather() async {
    setState(() {
      _loading = true;
    });

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final weatherData = await WeatherService.fetchWeatherByCoordinates(
        position.latitude,
        position.longitude,
      );

      final now = DateTime.now();
      final weekday = _getDayOfWeek(now.weekday);
      final date = '${now.month}/${now.day}/${now.year}';
      final weatherDescription = weatherData['weather'][0]['description'];
      final temperature = '${weatherData['main']['temp']}°C';
      final iconCode = weatherData['weather'][0]['icon'];
      final iconUrl = 'https://openweathermap.org/img/wn/$iconCode@2x.png';

      setState(() {
        _currentDay = weekday;
        _currentDate = date;
        _currentWeather = weatherDescription;
        _currentTemperature = temperature;
        _weatherIconUrl = iconUrl;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _currentWeather = 'Failed to fetch weather';
        _currentTemperature = 'N/A';
        _weatherIconUrl = '';
        _loading = false;
      });
    }
  }

  String _getDayOfWeek(int weekday) {
    const days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    return days[weekday - 1];
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
        title: const Text('Weatherly Dashboard'),
        centerTitle: true,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  color: Colors.grey[300],
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (_weatherIconUrl.isNotEmpty)
                        Image.network(
                          _weatherIconUrl,
                          width: 75,
                          height: 75,
                          fit: BoxFit.contain,
                        ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Date: $_currentDate',
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Day: $_currentDay',
                            style: const TextStyle(fontSize: 18),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Weather: $_currentWeather',
                            style: const TextStyle(fontSize: 18),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Temperature: $_currentTemperature',
                            style: const TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        buildButton(context, 'Weather Alerts', const WeatherAlertsScreen()),
                        buildButton(context, 'Detailed Forecast', DetailedForecastScreen()),
                        buildButton(context, 'Custom Backgrounds', const CustomizableBackgroundsScreen()),
                        buildButton(context, 'Interactive Maps', const InteractiveMapsScreen()),
                        buildButton(context, 'Community Insights', const CommunityInsightsScreen()),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget buildButton(BuildContext context, String title, Widget screen) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 50.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Colors.blueAccent,
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => screen),
          );
        },
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }
}
