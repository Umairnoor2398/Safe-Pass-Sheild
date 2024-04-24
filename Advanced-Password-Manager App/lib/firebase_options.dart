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
    apiKey: 'AIzaSyAZqnmqaCpxOrW9wiuRx5qMYyFPVvgbShA',
    appId: '1:438781899306:web:011d674ca1df30b510c953',
    messagingSenderId: '438781899306',
    projectId: 'advanced-password-manger',
    authDomain: 'advanced-password-manger.firebaseapp.com',
    storageBucket: 'advanced-password-manger.appspot.com',
    measurementId: 'G-65MF8H17BT',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA-Jj9WjcviS5eRgo7qvRP5h-D9WGxBatw',
    appId: '1:438781899306:android:ff66eb17b3aee07110c953',
    messagingSenderId: '438781899306',
    projectId: 'advanced-password-manger',
    storageBucket: 'advanced-password-manger.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDlmfOWSX0lCcYllDRk7CXaxfBUb4_LCBk',
    appId: '1:438781899306:ios:180de3903968326410c953',
    messagingSenderId: '438781899306',
    projectId: 'advanced-password-manger',
    storageBucket: 'advanced-password-manger.appspot.com',
    iosBundleId: 'com.thedbdevs.passManager',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDlmfOWSX0lCcYllDRk7CXaxfBUb4_LCBk',
    appId: '1:438781899306:ios:fd8c10d51a2f99d610c953',
    messagingSenderId: '438781899306',
    projectId: 'advanced-password-manger',
    storageBucket: 'advanced-password-manger.appspot.com',
    iosBundleId: 'com.thedbdevs.passManager.RunnerTests',
  );
}
