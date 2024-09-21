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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCRyy71g-YrA5oX0XbJc0un1DKUUBrp0fk',
    appId: '1:1049067408156:android:66f5f02ee8f750878888d9',
    messagingSenderId: '1049067408156',
    projectId: 'bhaktibhoomi',
    storageBucket: 'bhaktibhoomi.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAJnCUfg9HM1wNhDl_LKhGuXvvr8obxSxU',
    appId: '1:1049067408156:ios:9423372f5645be258888d9',
    messagingSenderId: '1049067408156',
    projectId: 'bhaktibhoomi',
    storageBucket: 'bhaktibhoomi.appspot.com',
    androidClientId: '1049067408156-innc7d22rm4rcb12ftsgrlehd7ne4vd3.apps.googleusercontent.com',
    iosClientId: '1049067408156-qkh30b3c9goht0but81gu9dclije4ckj.apps.googleusercontent.com',
    iosBundleId: 'com.vi5hnu.bhaktiBhoomi',
  );
}
