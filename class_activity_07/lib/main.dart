import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// Main application widget
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
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
  @override
  _AnimationDemoState createState() => _AnimationDemoState();
}

// State for AnimationDemo
class _AnimationDemoState extends State<AnimationDemo> {
  final bool _isVisible = true; // Track visibility of the text
  final double _scaleFactor = 1.0; // Scale factor for scaling animation
  final double _rotation = 0.0; // Rotation angle for rotation animation
  final double _translateX = 0.0; // Translation offset for sliding animation
  final Color _textColor = Colors.black; // Text color for color-changing animation
// State for AnimationDemo
class _AnimationDemoState extends State<AnimationDemo> {
  bool isVisible = true; // Track visibility of the text
  double scaleFactor = 1.0; // Scale factor for scaling animation
  double rotation = 0.0; // Rotation angle for rotation animation
  double translateX = 0.0; // Translation offset for sliding animation
  Color textColor = Colors.black; // Text color for color-changing animation

  // Function to toggle visibility and initiate animations
  void toggleAnimations() {
  // Function to toggle visibility and initiate animations
  void toggleAnimations() {
    setState(() {
      isVisible = !isVisible; // Toggle text visibility
      scaleFactor = isVisible ? 1.0 : 1.5; // Scale up or down
      rotation = isVisible ? 0.0 : 0.5; // Rotate 180 degrees
      translateX = isVisible ? 0.0 : 100.0; // Slide to the right
      textColor = isVisible ? Colors.black : Colors.red; // Change text color
      isVisible = !isVisible; // Toggle text visibility
      scaleFactor = isVisible ? 1.0 : 1.5; // Scale up or down
      rotation = isVisible ? 0.0 : 0.5; // Rotate 180 degrees
      translateX = isVisible ? 0.0 : 100.0; // Slide to the right
      textColor = isVisible ? Colors.black : Colors.red; // Change text color
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
              opacity: isVisible ? 1.0 : 0.0,
              duration: const Duration(seconds: 1),
              child: Text(
                'Fading Text',
                style: TextStyle(fontSize: 24, color: textColor),
              ),
            ),
            const SizedBox(height: 10), // Spacer

            // Animation 2: Scaling Text
            Transform.scale(
              scale: scaleFactor,
              child: const Text(
                'Scaling Text',
                style: TextStyle(fontSize: 24),
              ),
            ),
            const SizedBox(height: 10), // Spacer

            // Animation 3: Rotating Text
            Transform.rotate(
              angle: rotation * 3.14, // Convert rotation to radians
              child: const Text(
                'Rotating Text',
                style: TextStyle(fontSize: 24),
              ),
            ),
            const SizedBox(height: 10), // Spacer

            // Animation 4: Sliding Text
            Transform.translate(
              offset: Offset(translateX, 0), // Slide horizontally
              child: const Text(
                'Sliding Text',
                style: TextStyle(fontSize: 24),
              ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animation 1: Fading Text
            AnimatedOpacity(
              opacity: isVisible ? 1.0 : 0.0,
              duration: const Duration(seconds: 1),
              child: Text(
                'Fading Text',
                style: TextStyle(fontSize: 24, color: textColor),
              ),
            ),
            const SizedBox(height: 10), // Spacer

            // Animation 2: Scaling Text
            Transform.scale(
              scale: scaleFactor,
              child: const Text(
                'Scaling Text',
                style: TextStyle(fontSize: 24),
              ),
            ),
            const SizedBox(height: 10), // Spacer

            // Animation 3: Rotating Text
            Transform.rotate(
              angle: rotation * 3.14, // Convert rotation to radians
              child: const Text(
                'Rotating Text',
                style: TextStyle(fontSize: 24),
              ),
            ),
            const SizedBox(height: 10), // Spacer

            // Animation 4: Sliding Text
            Transform.translate(
              offset: Offset(translateX, 0), // Slide horizontally
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
