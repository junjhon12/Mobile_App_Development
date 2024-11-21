// TODO Implement this library.
import 'package:flutter/material.dart';

class BackgroundSelector extends StatelessWidget {
  final String theme;

  const BackgroundSelector({super.key, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/$theme.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      height: 300,
      width: double.infinity,
    );
  }
}
