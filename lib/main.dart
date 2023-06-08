import 'dart:developer';

import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'constants.dart';
import 'enums/app_theming.dart';
import 'providers/settings_providers.dart';
import 'themes/dark_theme/dark_theme.dart';
import 'themes/light_theme/light_theme.dart';
import 'themes/theme_color_schemes/dark_theme_color_scheme.dart';
import 'themes/theme_color_schemes/light_theme_color_scheme.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // // Adds Firebase Crashlytics to the app
  // FlutterError.onError = (errorDetails) {
  //   FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  // };
  // // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  // PlatformDispatcher.instance.onError = (error, stack) {
  //   FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
  //   return true;
  // };
  // final Future<FirebaseApp> firebaseApp = Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  runApp(
    ProviderScope(
      child: ResponsiveSizer(
        builder: (
          BuildContext context,
          Orientation orientation,
          ScreenType screenType,
        ) {
          return DynamicColorBuilder(
            builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
              ColorScheme lightColorScheme =
                  lightDynamic ?? lightThemeColorScheme;
              ColorScheme darkColorScheme = darkDynamic ?? darkThemeColorScheme;
              return Consumer(
                builder: (BuildContext context, WidgetRef ref, _) {
                  return MaterialApp(
                    title: 'Code Time',
                    debugShowCheckedModeBanner: false,
                    theme: lightTheme(lightColorScheme),
                    darkTheme: darkTheme(darkColorScheme),
                    themeMode:
                        ref.watch(appearanceProvider) == Appearance.system
                            ? ThemeMode.system
                            : ref.watch(appearanceProvider) == Appearance.light
                                ? ThemeMode.light
                                : ThemeMode.dark,
                    home: const MyApp(),
                  );
                },
              );
            },
          );
        },
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Healpen',
      home: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Wrap(
                  spacing: 8,
                  children: [
                    for (AppColor appColor in AppColor.values)
                      TextButton(
                        onPressed: () {
                          seedColor = appColor.color;
                          log(seedColor.toString(), name: 'seedColor');
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(appColor.color),
                          textStyle: MaterialStateProperty.all(
                              const TextStyle(color: Colors.white)),
                          foregroundColor: MaterialStateProperty.all(
                            appColor.color.computeLuminance() > 0.5
                                ? Colors.black
                                : Colors.white,
                          ),
                        ),
                        child: Text(appColor.name),
                      )
                  ],
                ),
                const Spacer(),
                const Expanded(
                  child: Card(
                    child: Center(
                      child: Text('Card'),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
