import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';

import 'enums/app_theming.dart';
import 'providers/settings_providers.dart';
import 'utils/constants.dart';
import 'utils/helper_functions.dart';

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
    const ProviderScope(
      child: MyApp(),
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
    log(
      context.theme.colorScheme.primary.toString(),
      name: 'context.theme.colorScheme.primary:before',
    );
    log(
      ref.watch(currentAppColorProvider).toString(),
      name: 'currentAppColorProvider:before',
    );
    return ResponsiveSizer(
      builder: (
        BuildContext context,
        Orientation orientation,
        ScreenType screenType,
      ) {
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
          darkTheme:
              getTheme(ref.watch(currentAppColorProvider), Brightness.dark),
          home: Scaffold(
            body: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: Wrap(
                      spacing: gap,
                      children: [
                        for (AppColor appColor in AppColor.values)
                          TextButton(
                            onPressed: () {
                              ref
                                  .watch(currentAppColorProvider.notifier)
                                  .state = appColor;
                              log(
                                ref.watch(currentAppColorProvider).toString(),
                                name: 'currentAppColorProvider',
                              );
                              setState(() {});
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                appColor.color,
                              ),
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
                  ),
                  const Spacer(flex: 2),
                  Expanded(
                    child: Card(
                      child: Center(
                        child: Text(
                          ref.watch(currentAppColorProvider).name,
                          style: context.theme.textTheme.displaySmall!.copyWith(
                            color: context.theme.cardTheme.color
                                        ?.computeLuminance() !=
                                    null
                                ? context.theme.cardTheme.color!
                                            .computeLuminance() >
                                        0.5
                                    ? Colors.black
                                    : Colors.white
                                : Colors.white,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
