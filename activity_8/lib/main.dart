// Tricky Halloween Game: Spooky Surprise
// Team Members: [junjhon12, anshuk-arun]

import 'package:flutter/material.dart';  // Import Flutter's core UI package.
import 'dart:math';  // Import the math package to generate random numbers.

void main() {
  // The starting point of the app.
  runApp(const TrickyHalloweenGame());
}

// This is the main widget for the game.
class TrickyHalloweenGame extends StatefulWidget {
  const TrickyHalloweenGame({super.key});

  @override
  _TrickyHalloweenGameState createState() => _TrickyHalloweenGameState();
}

// State class that holds the game logic and UI.
class _TrickyHalloweenGameState extends State<TrickyHalloweenGame>
    with SingleTickerProviderStateMixin {
  
  late AnimationController _controller;  // Controls animations for the game.
  final List<String> items = ['Bat', 'Ghost', 'Pumpkin', 'Spider', 'Witch'];  // List of possible game items.
  String? correctItem;  // The correct item that the player needs to find.
  String message = '';  // Message to display if the player wins or triggers a trap.
  bool isGameOver = false;  // Tracks whether the game has ended.

  @override
  void initState() {
    super.initState();
    // Initialize the animation controller with a duration of 2 seconds.
    _controller = AnimationController(
        vsync: this, duration: const Duration(seconds: 2))
      ..repeat(reverse: true);  // Repeat the animation in reverse after it finishes.

    _selectCorrectItem();  // Randomly select the "correct" item when the game starts.
  }

  // This function will play the background music.
  Future<void> _playBackgroundMusic(dynamic backgroundPlayer, dynamic LoopMode) async {
    await backgroundPlayer.setAsset('assets/music2.mp3');  // Load the music file.
    backgroundPlayer.setLoopMode(LoopMode.one);  // Loop the background music.
    backgroundPlayer.play();  // Start playing the music.
  }

  // This function randomly selects one of the items as the correct one.
  void _selectCorrectItem() {
    correctItem = items[Random().nextInt(items.length)];  // Randomly pick one item from the list.
  }

  // This function is called when an item is tapped.
  void _onItemTapped(String item) {
    if (item == correctItem) {
      // If the tapped item is the correct one, display a success message.
      setState(() {
        message = 'You Found It!';  // Success message.
        isGameOver = true;  // Mark the game as over.
      });
    } else {
      // If the wrong item is tapped, display a trap message.
      setState(() {
        message = 'Oh no! It\'s a trap!';  // Trap message.
      });
    }
  }

  @override
  void dispose() {
    // Clean up the animation controller when the widget is disposed of.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // The main UI for the game.
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Tricky Halloween Game')),  // The app's title bar.
        body: Stack(
          children: [
            // Background image for the game.
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/background.jfif'),  // Replace with your background image path.
                  fit: BoxFit.cover,  // Makes the image cover the entire screen.
                ),
              ),
            ),
            // The game items (Bats, Ghosts, etc.) are positioned randomly.
            Center(
              child: Stack(
                children: items.map((item) {
                  return AnimatedPositioned(
                    duration: const Duration(seconds: 2),
                    top: Random().nextDouble() * 400,  // Randomize vertical position.
                    left: Random().nextDouble() * 400,  // Randomize horizontal position.
                    child: GestureDetector(
                      // When the image is tapped, check if it's the correct item.
                      onTap: () => _onItemTapped(item),
                      child: Image.asset(
                        'assets/$item.jfif',  // Load the image for the current item.
                        width: 50,  // Set the width of the image.
                        height: 50,  // Set the height of the image.
                      ),
                    ),
                  );
                }).toList(),  // Convert the list of items to a list of widgets.
              ),
            ),
          ],
        ),
        // Bottom bar that displays messages (success or trap).
        bottomNavigationBar: BottomAppBar(
          child: Padding(
            padding: const EdgeInsets.all(8.0),  // Add padding to the message text.
            child: Text(
              message,  // Display the message based on game state.
              style: const TextStyle(fontSize: 24),  // Set the font size of the message.
            ),
          ),
        ),
      ),
    );
  }
}
