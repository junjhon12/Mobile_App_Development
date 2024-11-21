// TODO Implement this library.import 'dart:convert';
import 'dart:convert';

import 'package:http/http.dart' as http;

class WeatherApiService {
  static const String apiKey = 'your_api_key';

  static Future<Map<String, dynamic>> fetchCurrentWeather(String cityName) async {
    final url = 'https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apiKey&units=metric';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  static Future<List<dynamic>> fetchHourlyForecast(double lat, double lon) async {
    final url = 'https://api.openweathermap.org/data/2.5/onecall?lat=$lat&lon=$lon&exclude=current,minutely,daily&appid=$apiKey&units=metric';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return json.decode(response.body)['hourly'];
    } else {
      throw Exception('Failed to load hourly forecast');
    }
  }
}
