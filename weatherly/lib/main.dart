import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:math';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => WeatherService()),
        Provider(create: (_) => FirebaseMessagingService()),
      ],
      child: MaterialApp(
        title: 'Weatherly',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: PreferencesScreen(),
      ),
    );
  }
}

class PreferencesScreen extends StatefulWidget {
  @override
  _PreferencesScreenState createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  final String userId = "unique_user_id"; // Replace with your user's unique ID

  bool rainAlert = false;
  bool snowAlert = false;
  String theme = "sunny";
  String customBackground = "";

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch preferences from Firestore
  Future<void> loadPreferences() async {
    try {
      DocumentSnapshot snapshot =
          await _firestore.collection('user_preferences').doc(userId).get();
      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        setState(() {
          rainAlert = data["alerts"]["rain"] ?? false;
          snowAlert = data["alerts"]["snow"] ?? false;
          theme = data["theme"] ?? "sunny";
          customBackground = data["customBackground"] ?? "";
        });
      }
    } catch (e) {
      print("Error loading preferences: $e");
    }
  }

  // Save preferences to Firestore
  Future<void> savePreferences() async {
    try {
      final preferences = {
        "alerts": {"rain": rainAlert, "snow": snowAlert},
        "theme": theme,
        "customBackground": customBackground,
      };
      await _firestore
          .collection('user_preferences')
          .doc(userId)
          .set(preferences, SetOptions(merge: true));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Preferences saved successfully!')),
      );
    } catch (e) {
      print("Error saving preferences: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    loadPreferences(); // Load preferences on screen load
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Preferences'),
        actions: [
          IconButton(
            icon: Icon(Icons.map),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => WeatherMapScreen()),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SwitchListTile(
              title: Text('Rain Alert'),
              value: rainAlert,
              onChanged: (value) {
                setState(() {
                  rainAlert = value;
                });
              },
            ),
            SwitchListTile(
              title: Text('Snow Alert'),
              value: snowAlert,
              onChanged: (value) {
                setState(() {
                  snowAlert = value;
                });
              },
            ),
            DropdownButtonFormField<String>(
              value: theme,
              decoration: InputDecoration(labelText: 'Theme'),
              items: ['sunny', 'rainy', 'cloudy'].map((theme) {
                return DropdownMenuItem(
                  value: theme,
                  child: Text(theme),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  theme = value!;
                });
              },
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Custom Background URL',
              ),
              onChanged: (value) {
                setState(() {
                  customBackground = value;
                });
              },
              controller: TextEditingController(text: customBackground),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: savePreferences,
                child: Text('Save Preferences'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WeatherMapScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Weather Map')),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(37.7749, -122.4194), // Default to San Francisco
          zoom: 10,
        ),
      ),
    );
  }
}

class WeatherService {
  static const String apiKey = '56a7f11b63575f9939d2ff1f63603240';
  static const String baseUrl = 'https://api.openweathermap.org/data/2.5';

  Future<Map<String, dynamic>> fetchCurrentWeather(double lat, double lon) async {
    final response = await http.get(
      Uri.parse('$baseUrl/weather?lat=$lat&lon=$lon&appid=$apiKey&units=metric'),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch weather data');
    }
  }
}

class FirebaseMessagingService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  FirebaseMessagingService() {
    _initialize();
  }

  void _initialize() async {
    await _messaging.requestPermission();
    _messaging.subscribeToTopic('weather_alerts');
  }
}
