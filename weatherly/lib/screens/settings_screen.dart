import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: ListView(
        children: [
          ListTile(
            title: Text('Theme'),
            subtitle: Text('Choose a weather-based theme'),
            onTap: () {},
          ),
          ListTile(
            title: Text('Custom Background'),
            subtitle: Text('Upload your own background'),
            onTap: () {},
          ),
          ListTile(
            title: Text('Notifications'),
            subtitle: Text('Manage weather alerts'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
