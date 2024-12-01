import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final TextEditingController _cityController = TextEditingController();
  String _weatherData = '';
  final String _apiKey = '56a7f11b63575f9939d2ff1f63603240';

  Future<void> _fetchWeather() async {
    if (_cityController.text.isEmpty) {
      setState(() {
        _weatherData = 'Please enter a city name!';
      });
      return;
    }

    final url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=${_cityController.text}&appid=$_apiKey&units=metric');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _weatherData =
              'City: ${data['name']}\nTemperature: ${data['main']['temp']}°C\nCondition: ${data['weather'][0]['description']}';
        });
      } else {
        setState(() {
          _weatherData = 'Error: Unable to fetch weather data!';
        });
      }
    } catch (e) {
      setState(() {
        _weatherData = 'Error: ${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Weather App')),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _fetchWeather,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                child: const Text('Fetch Weather'),
              ),
              const SizedBox(height: 20),
              Text(
                _weatherData,
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/map');
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: const Text('View Map'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
