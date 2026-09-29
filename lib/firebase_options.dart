// This file is a placeholder. You need to run `flutterfire configure` to generate actual options.
// See https://firebase.google.com/docs/flutter/setup for more information.
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for android - '
          'go to https://firebase.google.com/docs/flutter/setup for details.',
        );
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'go to https://firebase.google.com/docs/flutter/setup for details.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'go to https://firebase.google.com/docs/flutter/setup for details.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'go to https://firebase.google.com/docs/flutter/setup for details.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'go to https://firebase.google.com/docs/flutter/setup for details.',
        );
      case TargetPlatform.fuchsia:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for fuchsia - '
          'go to https://firebase.google.com/docs/flutter/setup for details.',
        );
    }
  }
}
