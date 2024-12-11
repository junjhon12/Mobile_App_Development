import 'package:flutter/material.dart';

class DetailedForecastScreen extends StatelessWidget {
  DetailedForecastScreen({super.key});

  // Sample weather data for the hourly forecast
  final List<Map<String, String>> hourlyForecast = [
    {"time": "12:00 PM", "temp": "28°C", "weather": "Sunny", "icon": "🌞"},
    {"time": "01:00 PM", "temp": "29°C", "weather": "Partly Cloudy", "icon": "⛅"},
    {"time": "02:00 PM", "temp": "30°C", "weather": "Sunny", "icon": "🌞"},
    {"time": "03:00 PM", "temp": "31°C", "weather": "Hot", "icon": "🔥"},
    {"time": "04:00 PM", "temp": "30°C", "weather": "Cloudy", "icon": "☁️"},
    {"time": "05:00 PM", "temp": "28°C", "weather": "Rainy", "icon": "🌧️"},
    {"time": "06:00 PM", "temp": "27°C", "weather": "Clear", "icon": "🌙"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detailed Forecast')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title of the detailed forecast section
              const Text(
                'Hourly Weather Forecast:',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              // Display hourly forecast data in a list
              ListView.builder(
                shrinkWrap: true, // To prevent the list from expanding
                itemCount: hourlyForecast.length,
                itemBuilder: (context, index) {
                  final forecast = hourlyForecast[index];

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(10),
                      leading: Text(
                        forecast["icon"]!, // Weather icon (can be more complex)
                        style: const TextStyle(fontSize: 30),
                      ),
                      title: Text(
                        '${forecast["time"]} - ${forecast["temp"]}',
                        style: const TextStyle(fontSize: 18),
                      ),
                      subtitle: Text(
                        'Weather: ${forecast["weather"]}',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),

              // Title for the extended forecast (7-day forecast or other data)
              const Text(
                'Extended Forecast (Next 7 Days):',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),

              // Sample 7-day forecast
              GridView.builder(
                shrinkWrap: true, // To prevent the grid from expanding
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemCount: 7,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 4,
                    child: Column(
                      children: [
                        Text(
                          'Day ${index + 1}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '${(25 + index)}°C', // Randomized for the demo
                          style: const TextStyle(fontSize: 22),
                        ),
                        const SizedBox(height: 10),
                        const Icon(Icons.wb_sunny, size: 40), // Weather icon (can be changed based on actual forecast)
                      ],
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),

              // Other additional weather-related information
              const Text(
                'Additional Weather Information:',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text('Humidity: 65%'),
              const SizedBox(height: 5),
              const Text('Wind Speed: 12 km/h'),
              const SizedBox(height: 5),
              const Text('Pressure: 1012 hPa'),
            ],
          ),
        ),
      ),
    );
  }
}
