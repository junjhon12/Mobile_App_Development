import 'package:flutter/material.dart';

/*
Halloween Interactive Game Challenge

junjhon12
anshuk-arun

*/

void main() {
  runApp(const HalloweenApp());
}

class HalloweenApp extends StatelessWidget {
  const HalloweenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          
          // Background Image
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/Burial_Hill.png'),
              fit: BoxFit.cover,
            ),
          ),
          
          child: null,
          
        ),
      ),
    );
  }
}


/*

*/
