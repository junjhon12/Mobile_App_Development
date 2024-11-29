import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'screens/weather_screen.dart';
import 'screens/community_insights_screen.dart';
import 'screens/preferences_screen.dart';
import 'screens/live_radar_map_screen.dart';
import 'screens/satellite_map_screen.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const WeatherScreen(),
      routes: {
        '/community': (context) => const CommunityInsightsScreen(),
        '/preferences': (context) => const PreferencesScreen(),
        '/liveRadar': (context) => const LiveRadarMapScreen(),
        '/satellite': (context) => const SatelliteMapScreen(),
      },
    );
  }
}
