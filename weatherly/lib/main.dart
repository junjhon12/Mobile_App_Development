import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/weather_screen.dart';
import 'screens/map_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // If Firebase is not needed, you can omit this.
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => const WeatherScreen(),
        '/map': (context) => const MapScreen(),
      },
    );
  }
}
