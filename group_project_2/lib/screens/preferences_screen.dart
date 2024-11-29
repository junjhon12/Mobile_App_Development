import 'package:flutter/material.dart';

class PreferencesScreen extends StatelessWidget {
  const PreferencesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preferences'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Preferences Page',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              'Customize your app preferences here.',
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}