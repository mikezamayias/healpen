import 'dart:developer';

import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../enums/app_theming.dart';
import '../providers/settings_providers.dart';
import '../route_controller.dart';
import '../utils/constants.dart';
import '../utils/helper_functions.dart';
import '../widgets/custom_list_tile.dart';

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
          AnimatedSnackBar.removeAll();
        } else {
          ref.read(isDeviceConnectedProvider.notifier).state = false;
          AnimatedSnackBar(
            animationDuration: standardDuration,
            animationCurve: standardCurve,
            duration: 365.days,
            mobilePositionSettings: const MobilePositionSettings(
              topOnAppearance: 0,
              topOnDissapear: 0,
            ),
            builder: (BuildContext context) {
              return SafeArea(
                child: Padding(
                  padding: EdgeInsets.only(top: gap),
                  child: CustomListTile(
                    responsiveWidth: true,
                    titleString: 'You are offline',
                    cornerRadius: radius,
                    leadingIconData: FontAwesomeIcons.globe,
                    backgroundColor:
                        navigatorKey.currentContext!.theme.colorScheme.error,
                    textColor:
                        navigatorKey.currentContext!.theme.colorScheme.onError,
                  ),
                ),
              );
            },
          ).show(navigatorKey.currentContext!);
        }
        log(
          '$result',
          name: 'InternetConnectionChecker',
        );
        log(
          '${ref.read(isDeviceConnectedProvider.notifier).state}',
          name: 'device is connected',
        );
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
