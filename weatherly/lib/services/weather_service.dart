import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
<<<<<<< HEAD
  static const String _apiKey = '56a7f11b63575f9939d2ff1f63603240'; // Your API key
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  // Fetch weather by city name
  static Future<Map<String, dynamic>> fetchWeather(String cityName) async {
    final url = Uri.parse('$_baseUrl?q=$cityName&appid=$_apiKey&units=metric');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load weather: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error occurred while fetching weather: $e');
    }
  }

  // Fetch weather by coordinates
  static Future<Map<String, dynamic>> fetchWeatherByCoordinates(double lat, double lon) async {
    final url = Uri.parse('$_baseUrl?lat=$lat&lon=$lon&appid=$_apiKey&units=metric');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load weather: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error occurred while fetching weather by coordinates: $e');
=======
  static const String apiKey = '56a7f11b63575f9939d2ff1f63603240';
  const String baseUrl = 'https://api.openweathermap.org/data/2.5';

  Future<Map<String, dynamic>> getWeatherByLocation(double lat, double lon) async {
    final response = await http.get(
      Uri.parse('$baseUrl/weather?lat=$lat&lon=$lon&appid=$apiKey&units=metric'),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load weather data');
>>>>>>> main
    }
  }
}
