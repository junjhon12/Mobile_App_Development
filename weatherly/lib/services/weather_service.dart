import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  static const String _apiKey = '56a7f11b63575f9939d2ff1f63603240'; // Your API key
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  // Fetch weather by city name
  static Future<Map<String, dynamic>> fetchWeather(String cityName) async {
    final url = Uri.parse('$_baseUrl?q=$cityName&appid=$_apiKey&units=metric');
    
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load weather');
    }
  }

  // Fetch weather by coordinates
  static Future<Map<String, dynamic>> fetchWeatherByCoordinates(double lat, double lon) async {
    final url = Uri.parse('$_baseUrl?lat=$lat&lon=$lon&appid=$_apiKey&units=metric');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load weather');
    }
  }
}
