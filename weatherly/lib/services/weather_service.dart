import 'package:http/http.dart' as http;
import 'dart:convert';

class WeatherService {
  static const _apiKey = '56a7f11b63575f9939d2ff1f63603240';
  static const _baseUrl = 'https://api.openweathermap.org/data/2.5';

  static Future<Map<String, dynamic>> fetchWeather(String city) async {
    final url = '$_baseUrl/weather?q=$city&appid=$_apiKey&units=metric';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to fetch weather data');
    }
  }
}
