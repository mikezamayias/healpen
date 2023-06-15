import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'controllers/app_theming_controller.dart';
import 'firebase_options.dart';
import 'healpen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Adds Firebase Crashlytics to the app
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  final Future<FirebaseApp> firebaseApp = Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await AppColorController.instance.loadColor();
  await AppearanceController.instance.loadAppearance();

  runApp(
    ProviderScope(
      overrides: [
        AppColorController.instance.appColorControllerProvider.overrideWith(
          (ref) => AppColorController.instance,
        ),
        AppearanceController.instance.appearanceControllerProvider.overrideWith(
          (ref) => AppearanceController.instance,
        ),
      ],
      child: ResponsiveSizer(
        builder: (
          BuildContext context,
          Orientation orientation,
          ScreenType screenType,
        ) {
          return FutureBuilder(
            future: firebaseApp,
            builder: (context, snapshot) {
              return const Healpen();
            },
          );
        },
      ),
    ),
  );
}
