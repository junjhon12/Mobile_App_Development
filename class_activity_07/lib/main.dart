import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

// Main application widget
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AnimationDemo(), // Set the home screen to AnimationDemo
      home: AnimationDemo(), // Set the home screen to AnimationDemo
    );
  }
}

// Stateful widget for multiple animations
class AnimationDemo extends StatefulWidget {
  const AnimationDemo({super.key});

  @override
  _AnimationDemoState createState() => _AnimationDemoState();
  _AnimationDemoState createState() => _AnimationDemoState();
}

// State for AnimationDemo
class _AnimationDemoState extends State<AnimationDemo> {
  bool _isVisible = true; // Track visibility of the text
  double _scaleFactor = 1.0; // Scale factor for scaling animation
  double _rotation = 0.0; // Rotation angle for rotation animation
  double _translateX = 0.0; // Translation offset for sliding animation
  Color _textColor = Colors.black; // Text color for color-changing animation
// State for AnimationDemo
class _AnimationDemoState extends State<AnimationDemo> {
  bool _isVisible = true; // Track visibility of the text
  double _scaleFactor = 1.0; // Scale factor for scaling animation
  double _rotation = 0.0; // Rotation angle for rotation animation
  double _translateX = 0.0; // Translation offset for sliding animation
  Color _textColor = Colors.black; // Text color for color-changing animation

  // Function to toggle visibility and initiate animations
  void toggleAnimations() {
  // Function to toggle visibility and initiate animations
  void toggleAnimations() {
    setState(() {
      _isVisible = !_isVisible; // Toggle text visibility
      _scaleFactor = _isVisible ? 1.0 : 1.5; // Scale up or down
      _rotation = _isVisible ? 0.0 : 0.5; // Rotate 180 degrees
      _translateX = _isVisible ? 0.0 : 100.0; // Slide to the right
      _textColor = _isVisible ? Colors.black : Colors.red; // Change text color
      _isVisible = !_isVisible; // Toggle text visibility
      _scaleFactor = _isVisible ? 1.0 : 1.5; // Scale up or down
      _rotation = _isVisible ? 0.0 : 0.5; // Rotate 180 degrees
      _translateX = _isVisible ? 0.0 : 100.0; // Slide to the right
      _textColor = _isVisible ? Colors.black : Colors.red; // Change text color
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Animation Demo'), // App bar title
        title: const Text('Animation Demo'), // App bar title
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animation 1: Fading Text
            AnimatedOpacity(
              opacity: _isVisible ? 1.0 : 0.0,
              duration: const Duration(seconds: 1),
              child: Text(
                'Fading Text',
                style: TextStyle(fontSize: 24, color: _textColor),
              ),
            ),
            const SizedBox(height: 10), // Spacer

            // Animation 2: Scaling Text
            Transform.scale(
              scale: _scaleFactor,
              child: const Text(
                'Scaling Text',
                style: TextStyle(fontSize: 24),
              ),
            ),
            const SizedBox(height: 10), // Spacer

            // Animation 3: Rotating Text
            Transform.rotate(
              angle: _rotation * 3.14, // Convert rotation to radians
              child: const Text(
                'Rotating Text',
                style: TextStyle(fontSize: 24),
              ),
            ),
            const SizedBox(height: 10), // Spacer

            // Animation 4: Sliding Text
            Transform.translate(
              offset: Offset(_translateX, 0), // Slide horizontally
              child: const Text(
                'Sliding Text',
                style: TextStyle(fontSize: 24),
              ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animation 1: Fading Text
            AnimatedOpacity(
              opacity: _isVisible ? 1.0 : 0.0,
              duration: const Duration(seconds: 1),
              child: Text(
                'Fading Text',
                style: TextStyle(fontSize: 24, color: _textColor),
              ),
            ),
            const SizedBox(height: 10), // Spacer

            // Animation 2: Scaling Text
            Transform.scale(
              scale: _scaleFactor,
              child: const Text(
                'Scaling Text',
                style: TextStyle(fontSize: 24),
              ),
            ),
            const SizedBox(height: 10), // Spacer

            // Animation 3: Rotating Text
            Transform.rotate(
              angle: _rotation * 3.14, // Convert rotation to radians
              child: const Text(
                'Rotating Text',
                style: TextStyle(fontSize: 24),
              ),
            ),
            const SizedBox(height: 10), // Spacer

            // Animation 4: Sliding Text
            Transform.translate(
              offset: Offset(_translateX, 0), // Slide horizontally
              child: const Text(
                'Sliding Text',
                style: TextStyle(fontSize: 24),
              ),
            ),
            const SizedBox(height: 10), // Spacer

          ],
            const SizedBox(height: 10), // Spacer

          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: toggleAnimations, // Trigger all animations on button press
        onPressed: toggleAnimations, // Trigger all animations on button press
        child: const Icon(Icons.play_arrow), // Icon for the button
      ),
    );
  }
}
