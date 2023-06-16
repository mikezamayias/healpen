import 'dart:developer';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'controllers/app_theming_controller.dart';
import 'enums/app_theming.dart';
import 'firebase_options.dart';
import 'healpen.dart';
import 'models/app_theming_model.dart';
import 'utils/helper_functions.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseAnalytics.instance;

  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,
    // androidProvider: AndroidProvider.playIntegrity,
  );

  // Adds Firebase Crashlytics to the app
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  FirebaseUIAuth.configureProviders([
    EmailLinkAuthProvider(
      actionCodeSettings: ActionCodeSettings(
        url: 'https://healpen.page.link/email-link-sign-in',
        handleCodeInApp: true,
        androidMinimumVersion: '1',
        androidPackageName: 'com.mikezamayias.healpen',
        iOSBundleId: 'com.mikezamayias.healpen',
      ),
    ),
  ]);

  // Check if you received the link via `getInitialLink` first
  // final PendingDynamicLinkData? initialLink =
  //     await FirebaseDynamicLinks.instance.getInitialLink();

  // if (initialLink != null) {
  //   final Uri deepLink = initialLink.link;
  //   log(deepLink.path, name: 'deepLink.path');
  // }

  FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) {
    log(dynamicLinkData.link.path, name: 'dynamicLinkData.link.path');
  }).onError((error) {
    log(error, name: 'FirebaseDynamicLinks.instance.onLink.listen:onError');
  });

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
          return Consumer(
            builder: (BuildContext context, WidgetRef ref, _) {
              // Get the current values from the controllers
              AppColorModel appColorModel = ref.watch(
                  AppColorController.instance.appColorControllerProvider);
              AppearanceModel appearanceModel = ref.watch(
                  AppearanceController.instance.appearanceControllerProvider);

              // Use the values in your theme
              ThemeData theme = getTheme(
                appColorModel.appColor,
                appearanceModel.appearance == Appearance.dark
                    ? Brightness.dark
                    : Brightness.light,
              );
              return MaterialApp(
                title: 'Healpen',
                debugShowCheckedModeBanner: false,
                // themeMode: switch (currentAppearance) {
                //   Appearance.system => ThemeMode.system,
                //   Appearance.light => ThemeMode.light,
                //   Appearance.dark => ThemeMode.dark,
                // },
                color: appColorModel.appColor.color,
                theme: theme,
                //   home: (snapshot.connectionState == ConnectionState.waiting)
                //       ? const Scaffold(
                //           body: LoadingTile(durationTitle: 'Loading...'),
                //         )
                //       : snapshot.hasData
                //           ? const Healpen()
                //           : Scaffold(
                //               body: EmailLinkSignInScreen(
                //                 actions: [
                //                   AuthStateChangeAction<SignedIn>(
                //                       (context, state) {
                //                     Navigator.pushReplacement(
                //                       context,
                //                       MaterialPageRoute<void>(
                //                         builder: (BuildContext context) =>
                //                             const Healpen(),
                //                       ),
                //                     );
                //                   }),
                //                 ],
                //               ),
                //             ),
                initialRoute: '/email-link-sign-in',
                routes: {
                  '/email-link-sign-in': (context) => EmailLinkSignInScreen(
                        actions: [
                          AuthStateChangeAction<SignedIn>((context, state) {
                            Navigator.pushReplacementNamed(context, '/profile');
                          }),
                        ],
                      ),
                  '/': (context) => const Healpen(),
                },
              );
              // return StreamBuilder<User?>(
              //   stream: FirebaseAuth.instance.authStateChanges(),
              //   builder: (context, snapshot) {
              //     log(
              //       snapshot.data.toString(),
              //       name: 'FirebaseAuth.instance.authStateChanges()',
              //     );
              //     return MaterialApp(
              //       title: 'Healpen',
              //       debugShowCheckedModeBanner: false,
              //       // themeMode: switch (currentAppearance) {
              //       //   Appearance.system => ThemeMode.system,
              //       //   Appearance.light => ThemeMode.light,
              //       //   Appearance.dark => ThemeMode.dark,
              //       // },
              //       color: appColorModel.appColor.color,
              //       theme: theme,
              //       home: (snapshot.connectionState == ConnectionState.waiting)
              //           ? const Scaffold(
              //               body: LoadingTile(durationTitle: 'Loading...'),
              //             )
              //           : snapshot.hasData
              //               ? const Healpen()
              //               : Scaffold(
              //                   body: EmailLinkSignInScreen(
              //                     actions: [
              //                       AuthStateChangeAction<SignedIn>(
              //                           (context, state) {
              //                         Navigator.pushReplacement(
              //                           context,
              //                           MaterialPageRoute<void>(
              //                             builder: (BuildContext context) =>
              //                                 const Healpen(),
              //                           ),
              //                         );
              //                       }),
              //                     ],
              //                   ),
              //                 ),
              //     );
              //   },
              // );
            },
          );
        },
      ),
    ),
  );
}
