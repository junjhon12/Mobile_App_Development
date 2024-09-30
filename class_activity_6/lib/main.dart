import 'package:flutter/material.dart';

void main() {
  // Start the app by running the CounterImageToggleApp widget
  runApp(const CounterImageToggleApp());
}

class CounterImageToggleApp extends StatefulWidget {
  const CounterImageToggleApp({super.key});

  @override
  _CounterImageToggleAppState createState() => _CounterImageToggleAppState();
}

class _CounterImageToggleAppState extends State<CounterImageToggleApp> {
  int _counter = 0; // Variable to keep track of the counter value
  bool _isFirstImage = true; // Variable to track which image to show

  // Method to increment the counter value
  void _incrementCounter() {
    setState(() {
      _counter++; // Increase the counter by 1
    });
  }

  // Method to toggle between two images
  void _toggleImage() {
    setState(() {
      _isFirstImage = !_isFirstImage; // Switch between true and false
    });
  }

  // Method to reset the counter and image state
  void _reset() {
    setState(() {
      _counter = 0; // Reset counter to 0
      _isFirstImage = true; // Reset image to the first one
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Counter and Image Toggle App'), // App title in the app bar
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Center align widgets vertically
            children: <Widget>[
              // Display the image based on the _isFirstImage variable
              Image.asset(
                _isFirstImage ? 'assets/Pim.jfif' : 'assets/Charlie.png',
                height: 200, // Set image height
              ),
              const SizedBox(height: 20), // Space between image and text
              // Display the current counter value
              Text(
                'Counter: $_counter',
                style: const TextStyle(fontSize: 24), // Set text size
              ),
              const SizedBox(height: 20), // Space between text and buttons
              // Align buttons horizontally
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Distribute buttons evenly
                children: [
                  // Button to increment the counter
                  ElevatedButton(
                    onPressed: _incrementCounter, // Call _incrementCounter when pressed
                    child: const Text('Increment'), // Button text
                  ),
                  // Button to toggle the image
                  ElevatedButton(
                    onPressed: _toggleImage, // Call _toggleImage when pressed
                    child: const Text('Toggle Image'), // Button text
                  ),
                  // Button to reset counter and image
                  ElevatedButton(
                    onPressed: _reset, // Call _reset when pressed
                    child: const Text('Reset'), // Button text
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
