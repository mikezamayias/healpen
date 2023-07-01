import 'dart:developer';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_apple/firebase_ui_oauth_apple.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';

import 'enums/app_theming.dart';
import 'providers/custom_auth_provider.dart';
import 'providers/settings_providers.dart';
import 'utils/helper_functions.dart';

class HealpenWrapper extends ConsumerStatefulWidget {
  const HealpenWrapper({Key? key}) : super(key: key);

  @override
  ConsumerState<HealpenWrapper> createState() => _HealpenWrapperState();
}

class _HealpenWrapperState extends ConsumerState<HealpenWrapper>
    implements WidgetsBindingObserver {
  late final WidgetsBinding _widgetsBinding;
  late ThemeData theme;

  @override
  void initState() {
    readAppearance(ref);
    readAppColor(ref);
    _widgetsBinding = WidgetsBinding.instance;
    _widgetsBinding.addObserver(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    FirebaseUIAuth.configureProviders([
      ref.watch(CustomAuthProvider().emailLinkAuthProvider),
      GoogleProvider(
          clientId:
              '1058887275393-nujimnudrgjikn3c9uoqsra7i49n628m.apps.googleusercontent.com'),
      AppleProvider(),
    ]);
    theme = createTheme(
      ref.watch(appColorProvider).color,
      _widgetsBinding.platformDispatcher.platformBrightness,
    );
    return MaterialApp(
      title: 'Healpen',
      debugShowCheckedModeBanner: false,
      theme: theme,
      themeMode: switch (ref.watch(appearanceProvider)) {
        Appearance.system => ThemeMode.system,
        Appearance.light => ThemeMode.light,
        Appearance.dark => ThemeMode.dark,
      },
      initialRoute:
          FirebaseAuth.instance.currentUser == null ? '/sign-in' : '/profile',
      routes: {
        '/sign-in': (context) => SignInScreen(
              actions: [
                AuthStateChangeAction<SignedIn>(
                  (context, state) =>
                      context.navigator.pushReplacementNamed('/profile'),
                ),
              ],
            ),
        '/profile': (context) => ProfileScreen(
              actions: [
                SignedOutAction(
                  (context) =>
                      context.navigator.pushReplacementNamed('/sign-in'),
                ),
              ],
            )
      },
    );
  }

  @override
  void didChangeAccessibilityFeatures() {
    // TODO: implement didChangeAccessibilityFeatures
  }

  @override
  void didChangeLocales(List<Locale>? locales) {
    // TODO: implement didChangeLocales
  }

  @override
  void didChangeMetrics() {
    // TODO: implement didChangeMetrics
  }

  @override
  void didChangePlatformBrightness() {
    log(
      _widgetsBinding.platformDispatcher.platformBrightness.toString(),
      name: '_HealpenWrapperState:didChangePlatformBrightness',
    );
    setState(() {});
  }

  @override
  void didChangeTextScaleFactor() {
    // TODO: implement didChangeTextScaleFactor
  }

  @override
  void didHaveMemoryPressure() {
    // TODO: implement didHaveMemoryPressure
  }

  @override
  Future<bool> didPopRoute() {
    // TODO: implement didPopRoute
    throw UnimplementedError();
  }

  @override
  Future<bool> didPushRoute(String route) {
    // TODO: implement didPushRoute
    throw UnimplementedError();
  }

  @override
  Future<bool> didPushRouteInformation(RouteInformation routeInformation) {
    // TODO: implement didPushRouteInformation
    throw UnimplementedError();
  }

  @override
  Future<AppExitResponse> didRequestAppExit() {
    // TODO: implement didRequestAppExit
    throw UnimplementedError();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
  }
}
