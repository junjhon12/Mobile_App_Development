import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../widgets/forecast_list_widget.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final TextEditingController _cityController = TextEditingController();
  String _weatherInfo = "";
  List<dynamic> _forecastInfo = [];
  final String apiKey = "56a7f11b63575f9939d2ff1f63603240";
  File? _backgroundImage;

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
    final forecastResponse = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/forecast?q=$city&appid=$apiKey&units=metric'));

    if (response.statusCode == 200 && forecastResponse.statusCode == 200) {
      final data = json.decode(response.body);
      final forecastData = json.decode(forecastResponse.body);

      setState(() {
        _weatherInfo =
            'Temp: ${data['main']['temp']}°C, ${data['weather'][0]['description']}';
        _forecastInfo = forecastData['list'];
      });
    } else {
      setState(() {
        _weatherInfo = "Failed to load weather data.";
        _forecastInfo = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _cityController,
            decoration: const InputDecoration(
              labelText: 'Enter city',
            ),
          ),
          ElevatedButton(
            onPressed: _fetchWeather,
            child: const Text('Fetch Weather'),
          ),
          Text(_weatherInfo),
          if (_forecastInfo.isNotEmpty)
            ForecastListWidget(forecastInfo: _forecastInfo),
        ],
      ),
    );
  }
}
