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
    apiKey: 'AIzaSyCuTrBVeuWdPxBRiGuH4PK1CrOYiBUpb6k',
    appId: '1:829198517328:web:fa79a2d9a540702d31bd55',
    messagingSenderId: '829198517328',
    projectId: 'samplechatapp-43ca0',
    authDomain: 'samplechatapp-43ca0.firebaseapp.com',
    storageBucket: 'samplechatapp-43ca0.appspot.com',
    measurementId: 'G-FXV18BVW2B',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCYTq8uBFMBBG74q5-UHdaOyrgXFROIIyc',
    appId: '1:829198517328:android:93071e9de91a023331bd55',
    messagingSenderId: '829198517328',
    projectId: 'samplechatapp-43ca0',
    storageBucket: 'samplechatapp-43ca0.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBYPH0k5ZGgPy4kvRMCVHx6V_WOLkgslDg',
    appId: '1:829198517328:ios:49a8a03d966f7cd531bd55',
    messagingSenderId: '829198517328',
    projectId: 'samplechatapp-43ca0',
    storageBucket: 'samplechatapp-43ca0.appspot.com',
    androidClientId:
        '829198517328-ipqr51knkhl9fqlv0l0bgqqb7e7astp2.apps.googleusercontent.com',
    iosClientId:
        '829198517328-9a9ciql3nbk4nv8lrd4l5vo6tgf9kt19.apps.googleusercontent.com',
    iosBundleId: 'com.example.sampleChatApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBYPH0k5ZGgPy4kvRMCVHx6V_WOLkgslDg',
    appId: '1:829198517328:ios:49a8a03d966f7cd531bd55',
    messagingSenderId: '829198517328',
    projectId: 'samplechatapp-43ca0',
    storageBucket: 'samplechatapp-43ca0.appspot.com',
    androidClientId:
        '829198517328-ipqr51knkhl9fqlv0l0bgqqb7e7astp2.apps.googleusercontent.com',
    iosClientId:
        '829198517328-9a9ciql3nbk4nv8lrd4l5vo6tgf9kt19.apps.googleusercontent.com',
    iosBundleId: 'com.example.sampleChatApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCuTrBVeuWdPxBRiGuH4PK1CrOYiBUpb6k',
    appId: '1:829198517328:web:f831b40b0a28f61931bd55',
    messagingSenderId: '829198517328',
    projectId: 'samplechatapp-43ca0',
    authDomain: 'samplechatapp-43ca0.firebaseapp.com',
    storageBucket: 'samplechatapp-43ca0.appspot.com',
    measurementId: 'G-5T10VQ5H5D',
  );
}
