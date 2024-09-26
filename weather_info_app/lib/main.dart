import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Import the HTTP package to make API calls
import 'dart:convert'; // Import to convert JSON data

void main() {
  runApp(const WeatherApp()); // Entry point of the application, starts the WeatherApp
}

// Main WeatherApp widget that defines the state of the application
class WeatherApp extends StatefulWidget {
  const WeatherApp({super.key}); // Constructor for the WeatherApp widget

  @override
  State<WeatherApp> createState() => _WeatherAppState(); // Creates the state for WeatherApp
}

class _WeatherAppState extends State<WeatherApp> {
  // Variables to store user input and fetched weather data
  String cityName = ''; // Stores the name of the city entered by the user
  String temperature = '--'; // Placeholder for the temperature (default value)
  String weatherCondition = '--'; // Placeholder for weather condition (default value)
  
  // List to hold forecast data for the next 7 days
  List<Map<String, dynamic>> forecast = List.generate(7, (index) => {
        'day': 'Day ${index + 1}', // Default day label
        'temp': '--', // Default temperature placeholder
        'condition': 'N/A', // Default weather condition placeholder
      });

  List<String> citySuggestions = []; // List to hold city name suggestions based on user input

  // Function to fetch current weather data for the entered city
  Future<void> fetchWeather() async {
    final apiKey = 'YOUR_API_KEY'; // Replace with your OpenWeatherMap API key
    // Construct the URL for fetching weather data
    final url = Uri.parse('https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apiKey&units=metric');

    try {
      // Make an HTTP GET request to fetch weather data
      final response = await http.get(url);
      if (response.statusCode == 200) { // Check if the request was successful
        final data = jsonDecode(response.body); // Decode the JSON response
        
        // Update UI with fetched weather data
        setState(() {
          temperature = data['main']['temp'].toString(); // Get the temperature
          weatherCondition = data['weather'][0]['description']; // Get the weather condition
        });

        // Fetch the 7-day weather forecast using the latitude and longitude from the fetched data
        await fetch7DayForecast(data['coord']['lat'], data['coord']['lon']);
      } else {
        _handleError('City not found'); // Handle error if the city is not found
      }
    } catch (e) {
      _handleError('Error fetching data'); // Handle any other errors
    }
  }

  // Function to fetch the 7-day weather forecast based on the coordinates
  Future<void> fetch7DayForecast(double lat, double lon) async {
    final apiKey = 'YOUR_API_KEY'; // Replace with your OpenWeatherMap API key
    // Construct the URL for fetching the 7-day forecast data
    final url = Uri.parse('https://api.openweathermap.org/data/2.5/onecall?lat=$lat&lon=$lon&exclude=current,minutely,hourly,alerts&appid=$apiKey&units=metric');

    try {
      // Make an HTTP GET request to fetch forecast data
      final response = await http.get(url);
      if (response.statusCode == 200) { // Check if the request was successful
        final data = jsonDecode(response.body); // Decode the JSON response
        
        // Update UI with the fetched forecast data
        setState(() {
          // Generate a list of forecast data for the next 7 days
          forecast = List.generate(7, (index) {
            final dayData = data['daily'][index]; // Get data for each day
            return {
              'day': formatDate(dayData['dt']), // Format the date
              'temp': dayData['temp']['day'].toString(), // Get daily temperature
              'condition': dayData['weather'][0]['description'], // Get daily weather condition
            };
          });
        });
      }
    } catch (e) {
      _handleError('Error fetching forecast data'); // Handle errors while fetching forecast
    }
  }

  // Helper function to format the date from the timestamp
  String formatDate(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000); // Convert timestamp to DateTime
    return '${date.month}/${date.day}'; // Format as month/day
  }

  // Function to fetch city name suggestions based on user input
  Future<void> fetchCitySuggestions(String input) async {
    final apiKey = 'YOUR_API_KEY'; // Replace with your OpenWeatherMap API key
    // Construct the URL for fetching city suggestions
    final url = Uri.parse('http://api.openweathermap.org/data/2.5/find?q=$input&appid=$apiKey&units=metric');

    try {
      // Make an HTTP GET request to fetch city suggestions
      final response = await http.get(url);
      if (response.statusCode == 200) { // Check if the request was successful
        final data = jsonDecode(response.body); // Decode the JSON response
        
        // Update UI with city suggestions
        setState(() {
          citySuggestions = (data['list'] as List) // Cast the response to a List
              .map((city) => city['name']) // Extract city names
              .toList()
              .cast<String>()
              .where((city) => city.toLowerCase().contains(input.toLowerCase())) // Filter suggestions
              .toList();
        });
      } else {
        // Reset suggestions if no city found
        setState(() {
          citySuggestions = []; // Clear suggestions if no results
        });
      }
    } catch (e) {
      setState(() {
        citySuggestions = []; // Clear suggestions on error
      });
    }
  }

  // Function to handle errors and update UI with error messages
  void _handleError(String message) {
    setState(() {
      temperature = '--'; // Reset temperature
      weatherCondition = message; // Set error message as weather condition
    });
  }

  // Building the main UI of the app
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Disable the debug banner
      home: Scaffold(
        appBar: AppBar(
          title: const Center(child: Text('Weather App')), // App title
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Center the column content
            children: [
              const SizedBox(height: 5), // Spacer
              _buildInputContainer(), // Container for input and weather info
              const SizedBox(height: 20), // Spacer
              const Text('7-Day Forecast:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)), // Forecast title
              const SizedBox(height: 20), // Spacer
              _buildForecastRow(), // Display the 7-day forecast
            ],
          ),
        ),
      ),
    );
  }

  // Widget that holds the input field, fetch button, and weather info display
  Widget _buildInputContainer() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.4, // Set height relative to screen size
      width: MediaQuery.of(context).size.width * 0.6, // Set width relative to screen size
      padding: const EdgeInsets.all(5), // Padding inside the container
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10), // Rounded corners
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start, // Align children at the top
        children: [
          _buildCitySuggestions(), // Display city name suggestions
          const SizedBox(height: 5), // Spacer
          _buildCityInputField(), // Input field for city name
          const SizedBox(height: 5), // Spacer
          _buildFetchWeatherButton(), // Button to fetch weather data
          const SizedBox(height: 5), // Spacer
          _buildWeatherInfo(), // Display fetched weather info
        ],
      ),
    );
  }

  // Widget for displaying city suggestions in a list
  Widget _buildCitySuggestions() {
    return Container(
      height: 150, // Fixed height for suggestions container
      decoration: BoxDecoration(
        color: Colors.white, // Background color
        borderRadius: BorderRadius.circular(10), // Rounded corners
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))], // Shadow effect
      ),
      child: SingleChildScrollView(
        child: Column(
          children: citySuggestions.isNotEmpty // Check if there are suggestions
              ? citySuggestions.map((city) {
                  return ListTile(
                    title: Text(city), // Display city name
                    onTap: () {
                      setState(() {
                        cityName = city; // Set the selected city name
                        citySuggestions = []; // Clear suggestions after selection
                      });
                      fetchWeather(); // Fetch weather for selected city
                    },
                  );
                }).toList() // Convert the list of suggestions to a list of ListTiles
              : const [ListTile(title: Text('No suggestions'))], // Display message if no suggestions
        ),
      ),
    );
  }

  // Widget for the input field to enter the city name
  Widget _buildCityInputField() {
    return TextField(
      onChanged: (value) {
        setState(() {
          cityName = value; // Update cityName as the user types
          fetchCitySuggestions(value); // Fetch suggestions based on input
        });
      },
      decoration: InputDecoration(
        border: const OutlineInputBorder(), // Outline border for the input field
        hintText: 'Enter city name', // Hint text for user guidance
      ),
    );
  }

  // Widget for the button to fetch weather data
  Widget _buildFetchWeatherButton() {
    return ElevatedButton(
      onPressed: () {
        fetchWeather(); // Call fetchWeather when button is pressed
      },
      child: const Text('Get Weather'), // Button label
    );
  }

  // Widget to display fetched weather information
  Widget _buildWeatherInfo() {
    return Column(
      children: [
        Text('Temperature: $temperature °C', // Display the temperature
            style: const TextStyle(fontSize: 18)),
        Text('Condition: $weatherCondition', // Display the weather condition
            style: const TextStyle(fontSize: 18)),
      ],
    );
  }

  // Widget for displaying the 7-day weather forecast
  Widget _buildForecastRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Space items evenly in the row
      children: List.generate(forecast.length, (index) {
        // Generate forecast widgets for each day
        return Column(
          children: [
            Text(forecast[index]['day']), // Display day
            Text('${forecast[index]['temp']} °C'), // Display temperature
            Text(forecast[index]['condition']), // Display weather condition
          ],
        );
      }),
    );
  }
}
