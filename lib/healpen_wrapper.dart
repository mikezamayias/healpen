import 'dart:developer';

import 'package:feedback/feedback.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';

import 'enums/app_theming.dart';
import 'healpen.dart';
import 'providers/settings_providers.dart';
import 'utils/constants.dart';
import 'utils/helper_functions.dart';
import 'views/auth/auth_view.dart';
import 'views/note/note_view.dart';
import 'views/onboarding/onboarding_view.dart';
import 'widgets/auth_wrapper.dart';

class HealpenWrapper extends ConsumerStatefulWidget {
  const HealpenWrapper({Key? key}) : super(key: key);

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
      ref.watch(themeProvider.notifier).state = createTheme(
        ref.watch(themeColorProvider).color,
        brightness(ref.watch(themeAppearanceProvider)),
      );
      setState(() {
        getSystemUIOverlayStyle(
          context.theme,
          ref.watch(themeAppearanceProvider),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return HideKeyboard(
      child: BetterFeedback(
        theme: FeedbackThemeData(
          background: ref.watch(themeProvider).colorScheme.surfaceVariant,
          feedbackSheetColor: ref.watch(themeProvider).colorScheme.background,
          activeFeedbackModeColor:
              ref.watch(themeProvider).colorScheme.onPrimary,
          bottomSheetDescriptionStyle:
              ref.watch(themeProvider).textTheme.bodyLarge!,
          sheetIsDraggable: true,
          feedbackSheetHeight: 0.2,
          drawColors: [
            Colors.red,
            Colors.green,
            Colors.blue,
            Colors.yellow,
          ],
        ),
        child: MaterialApp(
          title: 'Healpen',
          scaffoldMessengerKey: scaffoldMessengerKey,
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
          navigatorObservers: [
            ClearFocusNavigatorObserver(),
          ],
          themeMode: themeMode(ref.watch(themeAppearanceProvider)),
          theme: ref.watch(themeProvider),
          initialRoute: '/auth-gate',
          routes: {
            '/onboarding': (context) => const OnboardingView(),
            '/auth': (context) => const AuthView(),
            '/healpen': (context) => const Healpen(),
            '/note': (context) => const NoteView(),
            '/auth-gate': (context) => const AuthWrapper(),
          },
        ),
      ),
    );
  }
}
