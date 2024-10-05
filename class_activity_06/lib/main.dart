// Importing necessary Dart and Flutter packages
import 'dart:io' show Platform; // For platform detection
import 'package:flutter/foundation.dart' show kIsWeb; // To check if the app is running on the web
import 'package:flutter/material.dart'; // For material design widgets
import 'package:provider/provider.dart'; // For state management
import 'package:window_size/window_size.dart'; // For controlling window size on desktop

// Main function to run the Flutter application
void main() {
  setupWindow(); // Set up the application window
  runApp(
    // Run the app with ChangeNotifierProvider for state management
    ChangeNotifierProvider(
      create: (context) => Counter(), // Create an instance of Counter
      child: const MyApp(), // Main application widget
    ),
  );
}

// Constants for window dimensions
const double windowWidth = 360; // Width of the window
const double windowHeight = 640; // Height of the window

// Function to set up the window properties
void setupWindow() {
  // Check if the app is not running on the web and is on a supported desktop platform
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    WidgetsFlutterBinding.ensureInitialized(); // Ensures the widget binding is initialized
    setWindowTitle('Provider Counter'); // Set the window title
    // Set the minimum and maximum sizes for the window
    setWindowMinSize(const Size(windowWidth, windowHeight));
    setWindowMaxSize(const Size(windowWidth, windowHeight));

    // Center the window on the current screen
    getCurrentScreen().then((screen) {
      setWindowFrame(Rect.fromCenter(
        center: screen!.frame.center, // Center position on the screen
        width: windowWidth, // Set width
        height: windowHeight, // Set height
      ));
    });
  }
}

// Counter class for managing state with ChangeNotifier
class Counter with ChangeNotifier {
  int value = 0; // Initial value of the counter

  // Method to increment the counter
  void increment() {
    value += 1; // Increase the value by 1
    notifyListeners(); // Notify listeners of the change
  }

  // Method to decrement the counter
  void decrement() {
    if (value > 0) { // Prevent going below zero
      value -= 1; // Decrease the value by 1
      notifyListeners(); // Notify listeners of the change
    }
  }
}

// MyApp widget as the root of the application
class MyApp extends StatelessWidget {
  const MyApp({super.key}); // Constructor

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo', // Title of the app
      theme: ThemeData(
        primarySwatch: Colors.blue, // Primary color for the theme
        useMaterial3: true, // Use Material Design 3
      ),
      home: const MyHomePage(), // Set the home page
    );
  }
}

// MyHomePage widget for the main interface
class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key}); // Constructor

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Demo Home Page'), // Title in the app bar
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Center the column
          children: [
            // Consumer widget to listen to changes in the Counter
            Consumer<Counter>(
              builder: (context, counter, child) => Text(
                'I am ${counter.value} years old', // Display the counter value
                style: Theme.of(context).textTheme.headlineMedium, // Apply text style
              ),
            ),
            const SizedBox(height: 5), // Spacer
            Column(
              mainAxisAlignment: MainAxisAlignment.center, // Center the buttons
              children: [
                // Button to increase age
                ElevatedButton(
                  onPressed: () {
                    var counter = context.read<Counter>(); // Access the Counter
                    counter.increment(); // Call increment method
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.resolveWith<Color>(
                          (Set<WidgetState> states) {
                        if (states.contains(WidgetState.pressed)) {
                          return Colors.lightBlue; // Change color when pressed
                        }
                        return Colors.blue; // Default color
                      },
                    ),
                    foregroundColor: WidgetStateProperty.all<Color>(Colors.white), // Set text color
                  ),
                  child: const Text('Increase Age'), // Button label
                ),
                const SizedBox(width: 20), // Spacer
                // Button to decrease age
                ElevatedButton(
                  onPressed: () {
                    var counter = context.read<Counter>(); // Access the Counter
                    counter.decrement(); // Call decrement method
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.resolveWith<Color>(
                          (Set<WidgetState> states) {
                        if (states.contains(WidgetState.pressed)) {
                          return Colors.lightBlue; // Change color when pressed
                        }
                        return Colors.blue; // Default color
                      },
                    ),
                    foregroundColor: WidgetStateProperty.all<Color>(Colors.white), // Set text color
                  ),
                  child: const Text('Decrease Age'), // Button label
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
