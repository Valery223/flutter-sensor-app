// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyAV5IBQi-wsXW5VFgAfwvmIsOzDuF6KmhQ',
    appId: '1:454418983603:web:59b646cb45e12d54965ec6',
    messagingSenderId: '454418983603',
    projectId: 'mobile-sensors-8d2ec',
    authDomain: 'mobile-sensors-8d2ec.firebaseapp.com',
    storageBucket: 'mobile-sensors-8d2ec.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyANcT9R4e-A0HFOUR2YMmomK-An8y_s3rQ',
    appId: '1:454418983603:android:408bed17f584d3e5965ec6',
    messagingSenderId: '454418983603',
    projectId: 'mobile-sensors-8d2ec',
    storageBucket: 'mobile-sensors-8d2ec.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCoi3RsQbTkhMKEOi02_G61gn4tPBtoJgc',
    appId: '1:454418983603:ios:50c0a47864c57993965ec6',
    messagingSenderId: '454418983603',
    projectId: 'mobile-sensors-8d2ec',
    storageBucket: 'mobile-sensors-8d2ec.appspot.com',
    iosBundleId: 'com.example.flatterAppAndroid',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCoi3RsQbTkhMKEOi02_G61gn4tPBtoJgc',
    appId: '1:454418983603:ios:89a1748d9fa7f13e965ec6',
    messagingSenderId: '454418983603',
    projectId: 'mobile-sensors-8d2ec',
    storageBucket: 'mobile-sensors-8d2ec.appspot.com',
    iosBundleId: 'com.example.flatterAppAndroid.RunnerTests',
  );
}