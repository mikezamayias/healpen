import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';

import '../enums/app_theming.dart';
import '../providers/settings_providers.dart';
import '../route_controller.dart';
import '../utils/constants.dart';
import '../utils/helper_functions.dart';

class HealpenWrapper extends ConsumerStatefulWidget {
  const HealpenWrapper({super.key});

  @override
  ConsumerState<HealpenWrapper> createState() => _HealpenWrapperState();
}

class _HealpenWrapperState extends ConsumerState<HealpenWrapper>
    with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    if (ref.watch(themeAppearanceProvider) == ThemeAppearance.system) {
      log(
        '${mediaQuery.platformBrightness}',
        name: '_HealpenWrapperState:didChangePlatformBrightness',
      );
      // TODO: figure a way to change the colors of smooth dot indicator on
      //  system appearance change without restarting the app
      setState(() {
        getSystemUIOverlayStyle(
          theme,
          ref.watch(themeAppearanceProvider),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return HideKeyboard(
      child: MaterialApp(
        title: 'Healpen',
        scaffoldMessengerKey: scaffoldMessengerKey,
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        navigatorObservers: [
          ClearFocusNavigatorObserver(),
        ],
        themeMode: themeMode(ref.watch(themeAppearanceProvider)),
        theme: createTheme(
          ref.watch(themeColorProvider).color,
          brightness(ref.watch(themeAppearanceProvider)),
        ),
        initialRoute: RouterController.authWrapperRoute.route,
        routes: RouterController().routes,
      ),
    );
  }
}
