import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

import '../firebase_options.dart';

class FirebaseService {
  // Singleton constructor
  static final FirebaseService _instance = FirebaseService._internal();

  factory FirebaseService() => _instance;

  FirebaseService._internal();

  // Methods

  /// Initializes the Firebase and related services for the app.
  /// Returns future that completes when all initialization tasks are done.
  static Future<void> initialize() async {
    /// Initializes Firebase App
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    /// Initializes Firebase Analytics
    FirebaseAnalytics.instance;

    /// Initializes Firebase AppCheck
    await FirebaseAppCheck.instance.activate(
      // androidProvider: AndroidProvider.playIntegrity,
      androidProvider: AndroidProvider.debug,
    );

    /// Initializes Firebase Crashlytics
    // Pass all uncaught errors from the framework to Crashlytics.
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
    // Pass all uncaught asynchronous errors that aren't handled by Flutter to
    // Crashlytics
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }
}
