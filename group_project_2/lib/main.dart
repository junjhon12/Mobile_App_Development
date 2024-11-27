import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:google_maps_flutter/google_maps_flutter.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WeatherScreen(),
    );
  }
}

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final TextEditingController _cityController = TextEditingController();
  String _weatherInfo = "";
  List<Map<String, dynamic>> _forecastInfo = [];
  final String apiKey = "56a7f11b63575f9939d2ff1f63603240";
  File? _backgroundImage;

  // Fetch current weather
  Future<void> _fetchWeather() async {
    final city = _cityController.text;
    if (city.isEmpty) {
      setState(() {
        _weatherInfo = "Please enter a city name.";
      });
      return;
    }

    final response = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _weatherInfo =
            'Temp: ${data['main']['temp']}°C, ${data['weather'][0]['description']}';
      });
    } else {
      setState(() {
        _weatherInfo = "Failed to load weather data.";
      });
    }
  }

  Future<void> _uploadCustomBackground() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _backgroundImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Weather App')),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PreferencesScreen()),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          if (_backgroundImage != null)
            Positioned.fill(
              child: Image.file(
                _backgroundImage!,
                fit: BoxFit.cover,
              ),
            ),
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        const Text(
                          'City name',
                          style: TextStyle(color: Colors.black, fontSize: 20),
                        ),
                        const SizedBox(height: 5),
                        TextField(
                          controller: _cityController,
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            hintText: 'Enter your city name',
                          ),
                        ),
                        const SizedBox(height: 15),
                        Column(
                          children: [
                            ElevatedButton(
                              onPressed: _fetchWeather,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Fetch Weather'),
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: _uploadCustomBackground,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueGrey,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Upload Background'),
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const CommunityInsightsScreen(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Community Insights'),
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LiveRadarMap(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Live Radar Map'),
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SatelliteMap(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Satellite Map'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    _weatherInfo,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Community Insights Screen
class CommunityInsightsScreen extends StatefulWidget {
  const CommunityInsightsScreen({super.key});

  @override
  _CommunityInsightsScreenState createState() =>
      _CommunityInsightsScreenState();
}

class _CommunityInsightsScreenState extends State<CommunityInsightsScreen> {
  final TextEditingController _reportController = TextEditingController();
  final List<String> _reports = [];
  final List<File> _photos = [];

  Future<void> _pickPhoto() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _photos.add(File(pickedFile.path));
      });
    }
  }

  void _submitReport() {
    final report = _reportController.text.trim();
    if (report.isNotEmpty) {
      setState(() {
        _reports.add(report);
        _reportController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Community Insights'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            const Text(
              'Share your observations or upload a photo!',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _reportController,
              decoration: const InputDecoration(
                labelText: 'Your weather observation',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _submitReport,
                    child: const Text('Submit Report'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _pickPhoto,
                    child: const Text('Upload Photo'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  if (_reports.isNotEmpty)
                    const Text(
                      'Community Reports:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ..._reports.map((report) => ListTile(
                        leading: const Icon(Icons.report),
                        title: Text(report),
                      )),
                  if (_photos.isNotEmpty)
                    const Text(
                      'Shared Photos:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ..._photos.map((photo) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Image.file(photo, height: 200, fit: BoxFit.cover),
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Live Radar Map Screen
class LiveRadarMap extends StatelessWidget {
  const LiveRadarMap({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Radar Map'),
      ),
      body: const Center(
        child: Text('Live Radar Map feature is under development.'),
      ),
    );
  }
}

// Satellite Map Screen
class SatelliteMap extends StatelessWidget {
  const SatelliteMap({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Satellite Map'),
      ),
      body: const Center(
        child: Text('Satellite Map feature is under development.'),
      ),
    );
  }
}

// Preferences Screen
class PreferencesScreen extends StatelessWidget {
  const PreferencesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preferences'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              'Preferences Page',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              'Customize your app preferences here.',
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
