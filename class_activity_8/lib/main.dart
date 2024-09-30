// Tricky Halloween Game: Spooky Surprise
// Team Members: [junjhon12, anshuk-arun]

import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(TrickyHalloweenGame());
}

class TrickyHalloweenGame extends StatefulWidget {
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
        vsync: this, duration: Duration(seconds: 2))
      ..repeat(reverse: true);
    _selectCorrectItem();
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
        appBar: AppBar(title: Text('Tricky Halloween Game')),
        body: Center(
          child: Stack(
            children: items.map((item) {
              return AnimatedPositioned(
                duration: Duration(seconds: 2),
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
              style: TextStyle(fontSize: 24),
            ),
          ),
        ),
      ),
    );
  }
}
