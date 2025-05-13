import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not configured for ${defaultTargetPlatform.name}',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'TU_API_KEY',
    appId: 'TU_APP_ID',
    messagingSenderId: 'TU_MESSAGING_SENDER_ID',
    projectId: 'TU_PROJECT_ID',
    storageBucket: 'TU_STORAGE_BUCKET',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    // Configuración de iOS si la tienes
    apiKey: 'TU_API_KEY_iOS',
    appId: 'TU_APP_ID_iOS',
    messagingSenderId: 'TU_MESSAGING_SENDER_ID',
    projectId: 'TU_PROJECT_ID',
    storageBucket: 'TU_STORAGE_BUCKET_iOS',
  );
}