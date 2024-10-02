import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

// Main application widget
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FadingTextAnimation(), // Set the home screen to FadingTextAnimation
    );
  }
}

// Stateful widget for fading text animation
class FadingTextAnimation extends StatefulWidget {
  @override
  _FadingTextAnimationState createState() => _FadingTextAnimationState();
}

// State for FadingTextAnimation
class _FadingTextAnimationState extends State<FadingTextAnimation> {
  bool _isVisible = true; // State variable to track visibility of the text

  // Function to toggle text visibility
  void toggleVisibility() {
    setState(() {
      _isVisible = !_isVisible; // Toggle the visibility state
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fading Text Animation'), // App bar title
      ),
      body: Center(
        child: GestureDetector(
          onTap: toggleVisibility, // Toggle visibility on tap
          child: AnimatedOpacity(
            opacity: _isVisible ? 1.0 : 0.0, // Set opacity based on visibility
            duration: const Duration(seconds: 1), // Animation duration
            curve: Curves.easeInOut, // Smooth curve for the animation
            child: const Text(
              'Hello, Flutter!', // Text to display
              style: TextStyle(fontSize: 24), // Text style
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: toggleVisibility, // Toggle visibility when button is pressed
        child: const Icon(Icons.play_arrow), // Icon for the button
      ),
    );
  }
}
