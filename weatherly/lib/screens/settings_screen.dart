import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Theme'),
            subtitle: const Text('Choose a weather-based theme'),
            onTap: () {},
          ),
          ListTile(
            title: const Text('Custom Background'),
            subtitle: const Text('Upload your own background'),
            onTap: () {},
          ),
          ListTile(
            title: const Text('Notifications'),
            subtitle: const Text('Manage weather alerts'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
