// Tricky Halloween Game: Spooky Surprise
// Team Members: [junjhon12, anshuk-arun]

import 'package:flutter/material.dart';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(const TrickyHalloweenGame());
}

class TrickyHalloweenGame extends StatefulWidget {
  const TrickyHalloweenGame({super.key});

  @override
  _TrickyHalloweenGameState createState() => _TrickyHalloweenGameState();
}

class _TrickyHalloweenGameState extends State<TrickyHalloweenGame>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<String> items = ['Bat', 'Ghost', 'Pumpkin', 'Spider', 'Witch'];
  String? correctItem;
  String message = '';
  bool isGameOver = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(seconds: 2))
      ..repeat(reverse: true);
    _selectCorrectItem();
  }

  Future<void> _playBackgroundMusic(dynamic _backgroundPlayer, dynamic LoopMode) async {
    await _backgroundPlayer.setAsset('assets/music2.mp3');
    var setLoopMode = _backgroundPlayer.setLoopMode(LoopMode.one); // Loop the background music
    var play = _backgroundPlayer.play();
  }

  void _selectCorrectItem() {
    correctItem = items[Random().nextInt(items.length)];
  }

  void _onItemTapped(String item) {
    if (item == correctItem) {
      setState(() {
        message = 'You Found It!';
        isGameOver = true;
      });
    } else {
      setState(() {
        message = 'Oh no! It\'s a trap!';
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Tricky Halloween Game')),
        body: Center(
          child: Stack(
            children: items.map((item) {
              print('Loading asset: assets/$item.jfif'); // Debugging line
              return AnimatedPositioned(
                duration: const Duration(seconds: 2),
                top: Random().nextDouble() * 400,
                left: Random().nextDouble() * 400,
                child: GestureDetector(
                  onTap: () => _onItemTapped(item),
                  child: Image.asset(
                    'assets/$item.jfif', // Adjust the path according to your images
                    width: 50,
                    height: 50,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              message,
              style: const TextStyle(fontSize: 24),
            ),
          ),
        ),
      ),
    );
  }
}
