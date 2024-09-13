import 'package:flutter/material.dart'; // Import the Flutter Material package for using Material Design components.

void main() {
  runApp(const RunMyApp()); // Entry point of the app that runs the MyApp widget.
}

// StatefulWidget is used when the state of the app can change dynamically.
class RunMyApp extends StatefulWidget {
  const RunMyApp({super.key}); // Constructor for the widget.

  @override
  State<RunMyApp> createState() => _RunMyAppState(); // Creates the mutable state for this widget.
}

// State class for RunMyApp. It holds the app's state, including the theme mode.
class _RunMyAppState extends State<RunMyApp> {
  ThemeMode _themeMode = ThemeMode.system; // Default theme mode is set to system (auto adjusts based on device settings).

  // This function changes the theme based on user selection.
  void changeTheme(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode; // Updates the state to reflect the new theme.
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Core app widget that provides Material Design structure to the app.
      
      // Light theme configuration
      theme: ThemeData(
        primarySwatch: Colors.blueGrey, // Primary color scheme for the light theme.
        brightness: Brightness.light, // Sets brightness to light theme.
        scaffoldBackgroundColor: Colors.white, // Background color of the app's scaffold (main UI background).
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontSize: 18, color: Colors.black), // Style for large body text in light theme.
        ),
      ),

      // Dark theme configuration
      darkTheme: ThemeData(
        brightness: Brightness.dark, // Sets brightness to dark theme.
        scaffoldBackgroundColor: Colors.black, // Background color for dark mode.
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontSize: 18, color: Colors.white), // Style for large body text in dark theme.
        ),
      ),

      themeMode: _themeMode, // Controls whether light or dark theme is applied based on the user selection.
      debugShowCheckedModeBanner: false, // Disables the "debug" banner that appears in the top right corner during development.

      home: HomeScreen(changeTheme: changeTheme), // Sets the home screen of the app, passing the changeTheme function.
    );
  }
}

// Home Screen widget which displays the main UI content.
class HomeScreen extends StatelessWidget {
  final Function(ThemeMode) changeTheme; // Function to change the app's theme.

  const HomeScreen({super.key, required this.changeTheme}); // Constructor for the home screen.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Basic Material Design structure with an app bar and body.
      appBar: AppBar(
        title: const Text('Theme Demo'), // Title for the app bar.
        actions: [
          IconButton(
            icon: const Icon(Icons.settings), // Settings icon.
            onPressed: () {
              // When the settings button is pressed, navigate to the SettingsScreen.
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsScreen(changeTheme: changeTheme),
                ),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: AnimatedContainer(
          // Container that animates when its properties change (like color).
          duration: const Duration(milliseconds: 500), // Animation duration of 500 milliseconds.
          padding: const EdgeInsets.all(16.0), // Padding inside the container.
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.grey[300] // Grey background in light mode.
                : Colors.white12, // Slightly lighter background in dark mode.
            borderRadius: BorderRadius.circular(12), // Rounded corners for the container.
          ),
          child: Text(
            'Mobile App Development Testing', // Text inside the container.
            style: Theme.of(context).textTheme.bodyLarge, // Text style defined in the current theme.
            textAlign: TextAlign.center, // Center align the text.
          ),
        ),
      ),
    );
  }
}

// Settings Screen widget that allows the user to switch between themes.
class SettingsScreen extends StatelessWidget {
  final Function(ThemeMode) changeTheme; // Function to change the app's theme.

  const SettingsScreen({super.key, required this.changeTheme}); // Constructor for the settings screen.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'), // Title for the settings screen.
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Centering content vertically.
          children: [
            Text('Switch Theme', style: Theme.of(context).textTheme.bodyLarge), // Text prompting the user to switch theme.
            const SizedBox(height: 20), // Adds vertical space between the text and the switch.
            Switch(
              value: Theme.of(context).brightness == Brightness.dark, // Switch position depends on the current theme.
              onChanged: (bool value) {
                // When the switch is toggled, change the theme.
                changeTheme(value ? ThemeMode.dark : ThemeMode.light); // Switches between dark and light themes.
              },
            ),
          ],
        ),
      ),
    );
  }
}
