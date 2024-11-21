// TODO Implement this library.
import 'package:cloud_firestore/cloud_firestore.dart';

class PreferencesService {
  Future<void> savePreferences(String userId, String theme, bool weatherAlerts) async {
    await FirebaseFirestore.instance.collection('users').doc(userId).set({
      'theme': theme,
      'weatherAlerts': weatherAlerts,
    });
  }

  Future<Map<String, dynamic>> getPreferences(String userId) async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    return snapshot.data() as Map<String, dynamic>;
  }
}
