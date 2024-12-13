import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:geolocator/geolocator.dart';
import 'package:weatherly/screens/home_screen.dart';
import './services/weather_service.dart';  // Make sure to import your service here.

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weatherly',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}

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
        // Correctly use the method from WeatherService
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather Alerts'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            ElevatedButton.icon(
              onPressed: _fetchWeatherByCurrentLocation,
              icon: const Icon(Icons.my_location),
              label: const Text('Use Current Location'),
            ),
            const SizedBox(height: 16),
            if (_loading)
              const CircularProgressIndicator(),
            if (_weatherInfo != null && !_loading)
              Text(
                _weatherInfo!,
                style: const TextStyle(fontSize: 18),
              ),
          ],
        ),
      ),
=======
import 'package:firebase_core/firebase_core.dart';
import 'screens/home_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/weather_map_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(WeatherlyApp());
}

class WeatherlyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weatherly',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/settings': (context) => SettingsScreen(),
        '/map': (context) => WeatherMapScreen(),
      },
>>>>>>> main
    );
  }
}
