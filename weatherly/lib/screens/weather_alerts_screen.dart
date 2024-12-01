import 'package:flutter/material.dart';
import '../services/weather_service.dart'; // Import your WeatherService class
import 'package:geolocator/geolocator.dart';
import 'detailed_forecast_screen.dart';  // Import DetailedForecastScreen

class WeatherAlertsScreen extends StatefulWidget {
  const WeatherAlertsScreen({super.key});

  @override
  State<WeatherAlertsScreen> createState() => _WeatherAlertsScreenState();
}

class _WeatherAlertsScreenState extends State<WeatherAlertsScreen> {
  final TextEditingController _locationController = TextEditingController();
  String? _weatherInfo;
  bool _loading = false;

  // Fetch weather for a manually entered location
  Future<void> _fetchWeatherByCity() async {
    final cityName = _locationController.text.trim();
    if (cityName.isNotEmpty) {
      setState(() {
        _loading = true;
      });
      try {
        final weatherData = await WeatherService.fetchWeather(cityName);
        setState(() {
          _weatherInfo = 'Weather in $cityName: ${weatherData['main']['temp']}°C';
        });
      } catch (e) {
        setState(() {
          _weatherInfo = 'Failed to fetch weather: $e';
        });
      } finally {
        setState(() {
          _loading = false;
        });
      }
    } else {
      setState(() {
        _weatherInfo = 'Please enter a city name.';
      });
    }
  }

  // Fetch weather for the current location
  Future<void> _fetchWeatherByCurrentLocation() async {
    setState(() {
      _loading = true;
    });

    try {
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        setState(() {
          _weatherInfo = 'Location permission denied.';
        });
        return;
      }

      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      final weatherData = await WeatherService.fetchWeatherByCoordinates(position.latitude, position.longitude);

      setState(() {
        _weatherInfo = 'Weather at your location: ${weatherData['main']['temp']}°C';
      });
    } catch (e) {
      setState(() {
        _weatherInfo = 'Failed to fetch weather for your location: $e';
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  // Navigate to Detailed Forecast screen
  void _navigateToDetailedForecast() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DetailedForecastScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather Alerts'),
        actions: [
          // Button to navigate to DetailedForecastScreen
          IconButton(
            icon: const Icon(Icons.navigate_next),
            onPressed: _navigateToDetailedForecast,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Input Bar
            TextField(
              controller: _locationController,
              decoration: InputDecoration(
                hintText: 'Enter a city name',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _fetchWeatherByCity,
                ),
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Fetch Weather by Current Location Button
            ElevatedButton.icon(
              onPressed: _fetchWeatherByCurrentLocation,
              icon: const Icon(Icons.my_location),
              label: const Text('Use Current Location'),
            ),
            const SizedBox(height: 16),

            // Weather Info Display
            if (_loading) 
              const CircularProgressIndicator(), // Show a loading spinner while fetching data
            if (_weatherInfo != null && !_loading)
              Text(
                _weatherInfo!,
                style: const TextStyle(fontSize: 18),
              ),
          ],
        ),
      ),
    );
  }
}
