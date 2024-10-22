import 'package:flutter/material.dart';
import 'dart:math';
import 'package:sqflite/sqflite.dart';
import 'database_helper.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aquarium',
      home: AquariumScreen(),
    );
  }
}

class AquariumScreen extends StatefulWidget {
  @override
  _AquariumScreenState createState() => _AquariumScreenState();
}

class _AquariumScreenState extends State<AquariumScreen> with SingleTickerProviderStateMixin {
  List<Fish> fishList = [];
  double _fishSpeed = 1.0; // Speed multiplier
  Color _selectedColor = Colors.orange; // Default color
  late AnimationController _controller;
  final DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(seconds: 2), vsync: this)
      ..repeat(); // Repeats the animation indefinitely
    _controller.addListener(() {
      setState(() {
        for (var fish in fishList) {
          fish.updatePosition();
        }
      });
    });
    _loadSettings(); // Load settings when the app starts
  }

  Future<void> _loadSettings() async {
    Map<String, dynamic> settings = await _dbHelper.loadSettings();
    setState(() {
      _fishSpeed = settings['fishSpeed'];
      _selectedColor = Color(settings['fishColor']);
      // Add fish based on the saved count
      for (int i = 0; i < settings['fishCount']; i++) {
        fishList.add(Fish(color: _selectedColor, speed: _fishSpeed));
      }
    });
  }

  void _addFish() {
    if (fishList.length < 10) { // Limiting to a maximum of 10 fish
      setState(() {
        fishList.add(Fish(color: _selectedColor, speed: _fishSpeed));
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Maximum of 10 fish allowed!')),
      );
    }
  }

  void _removeFish() {
    if (fishList.isNotEmpty) {
      setState(() {
        fishList.removeLast(); // Remove the last added fish
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No fish to remove!')),
      );
    }
  }

  Future<void> _saveSettings() async {
    await _dbHelper.saveSettings(
      fishList.length,
      _fishSpeed,
      _selectedColor.value,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Settings saved!')),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Aquarium UI'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.lightBlueAccent,
                border: Border.all(color: Colors.blueAccent, width: 2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Stack(
                children: fishList.map((fish) => fish.buildFish()).toList(),
              ),
            ),
            SizedBox(height: 20),
            Text('Fish Speed: ${_fishSpeed.toStringAsFixed(1)}x'),
            Slider(
              value: _fishSpeed,
              min: 0.5,
              max: 3.0,
              divisions: 5,
              label: _fishSpeed.toStringAsFixed(1),
              onChanged: (value) {
                setState(() {
                  _fishSpeed = value;
                });
              },
            ),
            SizedBox(height: 10),
            DropdownButton<Color>(
              value: _selectedColor,
              items: [
                DropdownMenuItem(
                  value: Colors.purple,
                  child: Text('Orange'),
                ),
                DropdownMenuItem(
                  value: Colors.blue,
                  child: Text('Blue'),
                ),
                DropdownMenuItem(
                  value: Colors.green,
                  child: Text('Green'),
                ),
                DropdownMenuItem(
                  value: Colors.red,
                  child: Text('Red'),
                ),
              ],
              onChanged: (Color? newColor) {
                setState(() {
                  if (newColor != null) _selectedColor = newColor;
                });
              },
              hint: Text('Select Color'),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _addFish,
                  child: Text('Add Fish'),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _removeFish,
                  child: Text('Remove Fish'),
                ),
              ],
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _saveSettings,
              child: Text('Save Settings'),
            ),
          ],
        ),
      ),
    );
  }
}

class Fish {
  Color color;
  double speed;
  double posX = 150; // Starting in the middle of the container
  double posY = 150;
  double directionX = 1.0; // Horizontal movement direction
  double directionY = 1.0; // Vertical movement direction
  final double radius = 15;

  Fish({required this.color, required this.speed}) {
    var random = Random();
    directionX = random.nextBool() ? 1.0 : -1.0;
    directionY = random.nextBool() ? 1.0 : -1.0;
  }

  void updatePosition() {
    posX += directionX * speed;
    posY += directionY * speed;

    if (posX <= radius || posX >= 300 - radius) {
      directionX *= -1;
    }
    if (posY <= radius || posY >= 300 - radius) {
      directionY *= -1;
    }
  }

  Widget buildFish() {
    return Positioned(
      left: posX,
      top: posY,
      child: CircleAvatar(
        radius: radius,
        backgroundColor: color,
      ),
    );
  }
}
