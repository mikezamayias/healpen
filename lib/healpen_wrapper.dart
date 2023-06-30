import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:magic_sdk/magic_sdk.dart';

import 'enums/app_theming.dart';
import 'providers/settings_providers.dart';
import 'utils/helper_functions.dart';
import 'views/login/login_view.dart';

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
    log(
      '${context.theme.brightness}',
      name: 'context.theme.brightness',
    );
    log(
      '${context.theme.scaffoldBackgroundColor}',
      name: 'context.theme.scaffoldBackgroundColor',
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
      home: Container(
        color: theme.scaffoldBackgroundColor,
        child: SafeArea(
          child: Stack(
            children: [
              const LoginView(),
              Magic.instance.relayer,
            ],
          ),
        ),
      ),
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
    setState(() {
      theme = createTheme(
        ref.watch(appColorProvider).color,
        _widgetsBinding.platformDispatcher.platformBrightness,
      );
    });
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
