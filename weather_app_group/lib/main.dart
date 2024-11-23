import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';

void main() => runApp(WeatherApp());

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WeatherAlertScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class WeatherAlertScreen extends StatefulWidget {
  const WeatherAlertScreen({super.key});

  @override
  _WeatherAlertScreenState createState() => _WeatherAlertScreenState();
}

class _WeatherAlertScreenState extends State<WeatherAlertScreen> {
  final TextEditingController _locationController = TextEditingController();
  String _selectedCondition = "Rain";
  final String _apiKey = "56a7f11b63575f9939d2ff1f63603240";

  void _checkWeather() async {
    String location = _locationController.text.trim();
    if (location.isEmpty) {
      Fluttertoast.showToast(msg: "Please enter a location");
      return;
    }

    final url =
        "https://api.openweathermap.org/data/2.5/weather?q=$location&appid=$_apiKey&units=metric";

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        String weatherCondition = data["weather"][0]["main"];

        if (weatherCondition == _selectedCondition) {
          Fluttertoast.showToast(
              msg: "Alert: $_selectedCondition detected in $location!");
        } else {
          Fluttertoast.showToast(
              msg: "No $_selectedCondition in $location currently.");
        }
      } else {
        Fluttertoast.showToast(
            msg: "Error: Unable to fetch weather for $location");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error: Something went wrong");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Weather Alerts"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _locationController,
              decoration: const InputDecoration(
                labelText: "Enter Location",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButton<String>(
              value: _selectedCondition,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedCondition = newValue!;
                });
              },
              items: ["Rain", "Snow", "Extreme"]
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _checkWeather,
              child: const Text("Check Weather"),
            ),
          ],
        ),
      ),
    );
  }
}
