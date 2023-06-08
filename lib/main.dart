import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'enums/app_theming.dart';
import 'providers/page_providers.dart';
import 'providers/settings_providers.dart';
import 'utils/helper_functions.dart';
import 'widgets/custom_bottom_navigation_bar.dart';

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
          return const MyApp();
        },
      ),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Healpen',
      debugShowCheckedModeBanner: false,
      themeMode: switch (ref.watch(appearanceProvider)) {
        Appearance.system => ThemeMode.system,
        Appearance.light => ThemeMode.light,
        Appearance.dark => ThemeMode.dark,
      },
      color: ref.watch(currentAppColorProvider).color,
      theme: getTheme(ref.watch(currentAppColorProvider), Brightness.light),
      darkTheme: getTheme(ref.watch(currentAppColorProvider), Brightness.dark),
      home: Scaffold(
        body: ref.watch(currentPageProvider).widget,
        bottomNavigationBar: const CustomBottomNavigationBar(),
      ),
    );
  }
}
