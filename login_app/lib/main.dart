import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Hides the top-right debug banner
      debugShowCheckedModeBanner: false,
      home: Scaffold(

        appBar: AppBar(
          title: Text('Login App'),
        ),

        body: Center(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.5,  // 50% height
            width: MediaQuery.of(context).size.width * 0.5,    // 50% width
            decoration: BoxDecoration(
              color: Colors.blue,  // Add some color or styling
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),



      ),
    );
  }
}
