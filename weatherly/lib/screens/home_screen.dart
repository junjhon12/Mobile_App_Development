import 'package:flutter/material.dart';
import '../widgets/weather_current_widget.dart';
import '../widgets/weather_forecast_widgets.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weatherly'),
        actions: [
          IconButton(
            icon: Icon(Icons.map),
            onPressed: () => Navigator.pushNamed(context, '/map'),
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () => Navigator.pushNamed(context, '/settings'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            WeatherCurrentWidget(),
            WeatherHourlyForecast(),
            WeatherWeeklyForecast(),
          ],
        ),
      ),
    );
  }
}
