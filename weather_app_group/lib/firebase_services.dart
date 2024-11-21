import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';

class FirebaseServices {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  Future<void> setupFirebase() async {
    await Firebase.initializeApp();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    print("Handling a background message: ${message.notification?.title}");
  }

  Future<void> requestNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission();
    print('User granted permission: ${settings.authorizationStatus}');
  }

  Future<void> saveUserPreferences(String userId, String theme, bool weatherAlerts) async {
    FirebaseFirestore.instance.collection('users').doc(userId).set({
      'theme': theme,
      'weatherAlerts': weatherAlerts,
    });
  }

  Future<Map<String, dynamic>> getUserPreferences(String userId) async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    return snapshot.data() as Map<String, dynamic>;
  }
}
