import 'package:flutter/material.dart';
import 'preferences_service.dart';

class UserPreferencesPage extends StatelessWidget {
  final String userId;

  UserPreferencesPage({required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('User Preferences')),
      body: FutureBuilder(
        future: PreferencesService().getPreferences(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading preferences'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No preferences found'));
          } else {
            var data = snapshot.data as Map<String, dynamic>;
            return Column(
              children: [
                SwitchListTile(
                  title: Text('Weather Alerts'),
                  value: data['weatherAlerts'],
                  onChanged: (bool value) {
                    // Save updated preferences
                  },
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
