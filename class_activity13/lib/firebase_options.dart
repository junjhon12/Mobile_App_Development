// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyB10XV5gH8HY5-d59XXjhCxy3DYYg12DSE',
    appId: '1:444099043067:web:cdaec3782a4c04f76cda5e',
    messagingSenderId: '444099043067',
    projectId: 'classactivity13-b70fb',
    authDomain: 'classactivity13-b70fb.firebaseapp.com',
    storageBucket: 'classactivity13-b70fb.firebasestorage.app',
    measurementId: 'G-8697SHX9G5',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC8NiHvfAXgQNdYFf5ahfkQQT_uNy3Xxz4',
    appId: '1:444099043067:android:007fae69eb47c3a86cda5e',
    messagingSenderId: '444099043067',
    projectId: 'classactivity13-b70fb',
    storageBucket: 'classactivity13-b70fb.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBjlDJKNES0Q3Bvc61c7zpbGxkEOSRMY24',
    appId: '1:444099043067:ios:263ec621496be1a76cda5e',
    messagingSenderId: '444099043067',
    projectId: 'classactivity13-b70fb',
    storageBucket: 'classactivity13-b70fb.firebasestorage.app',
    iosBundleId: 'com.example.classActivity13',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBjlDJKNES0Q3Bvc61c7zpbGxkEOSRMY24',
    appId: '1:444099043067:ios:263ec621496be1a76cda5e',
    messagingSenderId: '444099043067',
    projectId: 'classactivity13-b70fb',
    storageBucket: 'classactivity13-b70fb.firebasestorage.app',
    iosBundleId: 'com.example.classActivity13',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyB10XV5gH8HY5-d59XXjhCxy3DYYg12DSE',
    appId: '1:444099043067:web:fab5230eda375d1b6cda5e',
    messagingSenderId: '444099043067',
    projectId: 'classactivity13-b70fb',
    authDomain: 'classactivity13-b70fb.firebaseapp.com',
    storageBucket: 'classactivity13-b70fb.firebasestorage.app',
    measurementId: 'G-SY4S6BYXW8',
  );
}
