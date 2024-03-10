import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../controllers/analysis_view_controller.dart';
import '../enums/app_theming.dart';
import '../extensions/analysis_model_extensions.dart';
import '../providers/settings_providers.dart';
import '../route_controller.dart';
import '../utils/constants.dart';
import '../utils/helper_functions.dart';
import '../utils/logger.dart';

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
    InternetConnectionChecker().onStatusChange.listen(
      (InternetConnectionStatus result) async {
        if (result == InternetConnectionStatus.connected) {
          ref.read(isDeviceConnectedProvider.notifier).state = true;
        } else {
          ref.read(isDeviceConnectedProvider.notifier).state = false;
        }
      },
    );
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
      logger.i(
        '${mediaQuery.platformBrightness}',
      );
      getSystemUIOverlayStyle(
        theme,
        ref.watch(themeAppearanceProvider),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return HideKeyboard(
      child: MaterialApp(
        title: 'Healpen',
        scaffoldMessengerKey: scaffoldMessengerKey,
        debugShowCheckedModeBanner: false,
        navigatorObservers: [
          ClearFocusNavigatorObserver(),
          FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance)
        ],
        themeMode: themeMode(ref.watch(themeAppearanceProvider)),
        theme: createTheme(
          ref.watch(themeColorizeOnSentimentProvider)
              ? getShapeColorOnSentiment(
                  theme,
                  ref.watch(analysisModelSetProvider).averageScore(),
                )
              : ref.watch(themeColorProvider).color,
          brightness(ref.watch(themeAppearanceProvider)),
        ),
        initialRoute: RouterController.authWrapperRoute.route,
        routes: RouterController().routes,
      ),
    );
  }
}
