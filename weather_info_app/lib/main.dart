import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const WeatherApp());
}

class WeatherApp extends StatefulWidget {
  const WeatherApp({super.key});

  @override
  State<WeatherApp> createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  String cityName = '';
  String temperature = '--';
  String weatherCondition = '--';
  List<Map<String, dynamic>> forecast = List.generate(7, (index) => {
        'day': 'Day ${index + 1}',
        'temp': '--',
        'condition': 'N/A',
      });

  // List to hold city name suggestions
  List<String> citySuggestions = [];

  // Fetch current weather with city input
  Future<void> fetchWeather() async {
    final apiKey = '56a7f11b63575f9939d2ff1f63603240'; // Your API key
    final url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apiKey&units=metric');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          temperature = data['main']['temp'].toString();
          weatherCondition = data['weather'][0]['description'];
        });

        // Fetch 7-day forecast based on coordinates
        double lat = data['coord']['lat'];
        double lon = data['coord']['lon'];
        await fetch7DayForecast(lat, lon);
      } else {
        setState(() {
          temperature = '--';
          weatherCondition = 'City not found';
        });
      }
    } catch (e) {
      setState(() {
        temperature = '--';
        weatherCondition = 'Error fetching data';
      });
    }
  }

  // Fetch the 7-day forecast using OpenWeather One Call API
  Future<void> fetch7DayForecast(double lat, double lon) async {
    final apiKey = '56a7f11b63575f9939d2ff1f63603240'; // Your API key
    final url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/onecall?lat=$lat&lon=$lon&exclude=current,minutely,hourly,alerts&appid=$apiKey&units=metric');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        // Update the forecast data in the state
        setState(() {
          forecast = List.generate(7, (index) {
            final dayData = data['daily'][index];
            return {
              'day': formatDate(dayData['dt']),
              'temp': dayData['temp']['day'].toString(),
              'condition': dayData['weather'][0]['description'],
            };
          });
        });
      }
    } catch (e) {
      // Error handling for forecast data
      setState(() {
        forecast = List.generate(7, (index) => {
              'day': 'Day ${index + 1}',
              'temp': '--',
              'condition': 'Error fetching data',
            });
      });
    }
  }

  // Convert Unix timestamp to readable date
  String formatDate(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return '${date.month}/${date.day}';
  }

  // Fetch city suggestions based on user input
  Future<void> fetchCitySuggestions(String input) async {
    final apiKey = '56a7f11b63575f9939d2ff1f63603240'; // Your API key
    final url = Uri.parse(
        'http://api.openweathermap.org/data/2.5/find?q=$input&appid=$apiKey&units=metric');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          citySuggestions = (data['list'] as List)
              .map((city) => city['name'])
              .toList()
              .cast<String>()
              .where((city) => city.toLowerCase().contains(input.toLowerCase())) // Filter based on input
              .toList();
        });
      } else {
        setState(() {
          citySuggestions = [];
        });
      }
    } catch (e) {
      setState(() {
        citySuggestions = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Center(child: Text('Weather App')),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 5),
              Container(
                height: MediaQuery.of(context).size.height * 0.4,
                width: MediaQuery.of(context).size.width * 0.6,
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Display city suggestions above the text field
                    Container(
                      height: 150, // Fixed height for the suggestions list
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          children: citySuggestions.isNotEmpty
                              ? citySuggestions.map((city) {
                                  return ListTile(
                                    title: Text(city),
                                    onTap: () {
                                      setState(() {
                                        cityName = city;
                                        citySuggestions = []; // Clear suggestions after selection
                                      });
                                      fetchWeather(); // Fetch weather for the selected city
                                    },
                                  );
                                }).toList()
                              : [
                                  const ListTile(
                                    title: Text('No suggestions'),
                                  ),
                                ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),

                    TextField(
                      onChanged: (value) {
                        cityName = value;
                        fetchCitySuggestions(value); // Fetch city suggestions
                      },
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
                        onPressed: fetchWeather,
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
                    Row(
                      children: [
                        Text(
                          'Temperature: $temperature°C',
                          style: const TextStyle(fontSize: 20,),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'Condition: $weatherCondition',
                          style: const TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                '7-Day Forecast:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: forecast.map((dayData) {
                      return Container(
                        color: Colors.white,
                        margin: const EdgeInsets.symmetric(horizontal: 5.5),
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            const Icon(Icons.wb_sunny),
                            Text(dayData['day']),
                            Text('Temp: ${dayData['temp']}°C'),
                            Text(dayData['condition']),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
