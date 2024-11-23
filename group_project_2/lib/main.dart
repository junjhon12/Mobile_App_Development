import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  runApp(const weatherApp());
}

class weatherApp extends StatelessWidget {
  const weatherApp({super.key});

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
        _changeBackgroundBasedOnWeather(data['weather'][0]['description']);
      });
      await _checkForAlerts(data);
    } else {
      setState(() {
        _weatherInfo = "Failed to load weather data.";
      });
    }
  }

  // Fetch 7-day forecast
  Future<void> _fetchForecast() async {
    final city = _cityController.text;
    if (city.isEmpty) {
      setState(() {
        _forecastInfo = [];
      });
      return;
    }

    final response = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/forecast?q=$city&cnt=7&appid=$apiKey&units=metric'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _forecastInfo = [];
        for (var day in data['list']) {
          final date = DateTime.fromMillisecondsSinceEpoch(day['dt'] * 1000);
          final dayOfWeek = _getDayOfWeek(date.weekday);
          _forecastInfo.add({
            'day': dayOfWeek,
            'temp': day['main']['temp'],
            'description': day['weather'][0]['description'],
          });
        }
      });
    } else {
      setState(() {
        _forecastInfo = [];
      });
    }
  }

  // Get day of the week
  String _getDayOfWeek(int weekday) {
    switch (weekday) {
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thu';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      case 7:
        return 'Sun';
      default:
        return '';
    }
  }

  // Change background based on weather
  void _changeBackgroundBasedOnWeather(String weatherDescription) {
    if (_backgroundImage == null) {
      if (weatherDescription.contains("clear") || weatherDescription.contains("sunny")) {
        setState(() {
          _backgroundImage = null; // Reset to default background or sunny theme
        });
      } else if (weatherDescription.contains("rain")) {
        setState(() {
          _backgroundImage = null; // Set a rainy day theme
        });
      } else if (weatherDescription.contains("snow")) {
        setState(() {
          _backgroundImage = null; // Set a snowy day theme
        });
      } else {
        setState(() {
          _backgroundImage = null; // Default background for other weather types
        });
      }
    }
  }

  // Allow user to upload custom background
  Future<void> _uploadCustomBackground() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

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
                MaterialPageRoute(builder: (context) => PreferencesScreen()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 5),
            Container(
              height: MediaQuery.of(context).size.height * 0.3,
              width: MediaQuery.of(context).size.width * 0.6,
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
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
                  const SizedBox(height: 5),
                  Expanded(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: ElevatedButton(
                        onPressed: _fetchWeather,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          textStyle: const TextStyle(fontSize: 15),
                        ),
                        child: const Text('Fetch Weather'),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Expanded(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: ElevatedButton(
                        onPressed: _fetchForecast,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          textStyle: const TextStyle(fontSize: 15),
                        ),
                        child: const Text('7-Day Forecast'),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _uploadCustomBackground,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        textStyle: const TextStyle(fontSize: 15),
                      ),
                      child: const Text('Upload Custom Background'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              _weatherInfo,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _backgroundImage == null
                ? Container() // Add default background if no custom background is uploaded
                : Image.file(
                    _backgroundImage!,
                    fit: BoxFit.cover,
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                  ),
            const SizedBox(height: 20),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _forecastInfo.map((forecast) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5.0),
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.blueGrey.shade100,
                    ),
                    child: Column(
                      children: [
                        Text(
                          forecast['day'],
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5),
                        Text('${forecast['temp']}°C'),
                        const SizedBox(height: 5),
                        Text(forecast['description']),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _checkForAlerts {
  _checkForAlerts(data);

  static Future<void> checkWeatherAlerts(Map<String, dynamic> weatherData) async {
    final prefs = await SharedPreferences.getInstance();
    final String lastChecked = prefs.getString('lastChecked') ?? '';
    final weatherDescription = weatherData['weather'][0]['description'];

    if (lastChecked != weatherDescription) {
      final androidDetails = AndroidNotificationDetails(
        'channel_id',
        'Weather Alerts',
        channelDescription: 'Weather Notifications',
        importance: Importance.high,
        priority: Priority.high,
      );

      var notificationDetails = NotificationDetails(android: androidDetails);

      await flutterLocalNotificationsPlugin.show(
        0,
        'Weather Alert!',
        'Current Weather: $weatherDescription',
        notificationDetails,
      );

      await prefs.setString('lastChecked', weatherDescription);
    }
  }
}

class PreferencesScreen extends StatelessWidget {
  const PreferencesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Preferences"),
      ),
      body: const Center(child: Text('Preferences screen')),
    );
  }
}
