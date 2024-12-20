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
    apiKey: 'AIzaSyDn7kA3i6MDHHUIDX3OMxmS2RVX9IJkm1Y',
    appId: '1:504913277435:web:7fa47af82038f23d365b5e',
    messagingSenderId: '504913277435',
    projectId: 'homework-4-fcc09',
    authDomain: 'homework-4-fcc09.firebaseapp.com',
    storageBucket: 'homework-4-fcc09.firebasestorage.app',
    measurementId: 'G-GWRBH8FHYH',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAe1EMfJwCtRMYuDwHkRKJTKQcL1hNojsc',
    appId: '1:504913277435:android:26741b9b998b0751365b5e',
    messagingSenderId: '504913277435',
    projectId: 'homework-4-fcc09',
    storageBucket: 'homework-4-fcc09.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAm3zzV8GSsFEKFh23Knrn4TwAT88QYRHw',
    appId: '1:504913277435:ios:9e8f8d34af961946365b5e',
    messagingSenderId: '504913277435',
    projectId: 'homework-4-fcc09',
    storageBucket: 'homework-4-fcc09.firebasestorage.app',
    iosBundleId: 'com.example.hw4',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAm3zzV8GSsFEKFh23Knrn4TwAT88QYRHw',
    appId: '1:504913277435:ios:9e8f8d34af961946365b5e',
    messagingSenderId: '504913277435',
    projectId: 'homework-4-fcc09',
    storageBucket: 'homework-4-fcc09.firebasestorage.app',
    iosBundleId: 'com.example.hw4',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDn7kA3i6MDHHUIDX3OMxmS2RVX9IJkm1Y',
    appId: '1:504913277435:web:7247fcf5bd227c21365b5e',
    messagingSenderId: '504913277435',
    projectId: 'homework-4-fcc09',
    authDomain: 'homework-4-fcc09.firebaseapp.com',
    storageBucket: 'homework-4-fcc09.firebasestorage.app',
    measurementId: 'G-6KQLFVMD5X',
  );
}
