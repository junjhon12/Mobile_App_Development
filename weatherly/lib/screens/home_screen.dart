import 'package:flutter/material.dart';
import 'weather_alerts_screen.dart';
import 'detailed_forecast_screen.dart';
import 'customizable_backgrounds_screen.dart';
import 'interactive_maps_screen.dart';
import 'community_insights_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Weatherly Dashboard')),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildButton(context, 'Weather Alerts', WeatherAlertsScreen()),
            _buildButton(context, 'Detailed Forecast', DetailedForecastScreen()),
            _buildButton(context, 'Custom Backgrounds', CustomizableBackgroundsScreen()),
            _buildButton(context, 'Interactive Maps', InteractiveMapsScreen()),
            _buildButton(context, 'Community Insights', CommunityInsightsScreen()),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, String title, Widget screen) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => screen)),
        child: Text(title),
      ),
    );
  }
}
