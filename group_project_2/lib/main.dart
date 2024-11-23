import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const weatherApp());
}

class weatherApp extends StatelessWidget {
  const weatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const WeatherScreen(),
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

  // Fetch current weather for a given city
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

  // Fetch 7-day weather forecast for a given city
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
        // Get the current date
        final currentDate = DateTime.now();

        // Loop through the forecast data and filter out the current day
        for (var day in data['list']) {
          final date = DateTime.fromMillisecondsSinceEpoch(day['dt'] * 1000);
          if (date.day != currentDate.day) {  // Skip current day
            final dayOfWeek = _getDayOfWeek(date.weekday);
            _forecastInfo.add({
              'day': dayOfWeek,
              'temp': day['main']['temp'],
              'description': day['weather'][0]['description'],
            });
          }
        }
      });
    } else {
      setState(() {
        _forecastInfo = [];
      });
    }
  }

  // Convert weekday number to day of the week string
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Weather App')),
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
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: ElevatedButton(
                      onPressed: _fetchWeather,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        textStyle: const TextStyle(fontSize: 15),
                      ),
                      child: const Text(
                        'Fetch Weather',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: ElevatedButton(
                      onPressed: _fetchForecast,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        textStyle: const TextStyle(fontSize: 15),
                      ),
                      child: const Text(
                        '7-Day Forecast',
                        style: TextStyle(color: Colors.white),
                      ),
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
            // Display the 7-day forecast horizontally
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
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          '${forecast['temp']}°C',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          forecast['description'],
                          style: const TextStyle(fontSize: 14),
                        ),
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
