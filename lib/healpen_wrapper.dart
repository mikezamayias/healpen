import 'dart:developer';

import 'package:feedback/feedback.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iterum/flutter_iterum.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';

import 'controllers/onboarding/onboarding_controller.dart';
import 'controllers/settings/preferences_controller.dart';
import 'enums/app_theming.dart';
import 'healpen.dart';
import 'providers/settings_providers.dart';
import 'utils/constants.dart';
import 'utils/helper_functions.dart';
import 'views/auth/auth_view.dart';
import 'views/note/note_view.dart';
import 'views/onboarding/onboarding_view.dart';

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
  void didChangeDependencies() async {
    PreferencesController.themeAppearance.read().then(
          (ThemeAppearance value) =>
              ref.watch(themeAppearanceProvider.notifier).state = value,
        );
    PreferencesController.themeColor.read().then(
          (ThemeColor value) =>
              ref.watch(themeColorProvider.notifier).state = value,
        );
    PreferencesController.shakePrivateNoteInfo.read().then(
          (bool value) =>
              ref.watch(shakePrivateNoteInfoProvider.notifier).state = value,
        );
    PreferencesController.writingAutomaticStopwatch.read().then(
          (bool value) => ref
              .watch(writingAutomaticStopwatchProvider.notifier)
              .state = value,
        );
    PreferencesController.navigationShowBackButton.read().then(
          (bool value) => ref
              .watch(navigationShowBackButtonProvider.notifier)
              .state = value,
        );
    PreferencesController.onboardingCompleted.read().then(
          (bool value) => ref
              .watch(
                  OnboardingController().onboardingCompletedProvider.notifier)
              .state = value,
        );
    PreferencesController.navigationEnableHapticFeedback.read().then(
          (bool value) => ref
              .watch(navigationEnableHapticFeedbackProvider.notifier)
              .state = value,
        );
    PreferencesController.navigationShowAppBarTitle.read().then(
          (bool value) =>
              ref.watch(navigationShowAppBarTitle.notifier).state = value,
        );
    PreferencesController.writingShowAnalyzeNotesButton.read().then(
          (bool value) => ref
              .watch(writingShowAnalyzeNotesButtonProvider.notifier)
              .state = value,
        );
    PreferencesController.navigationShowInfoButtons.read().then(
          (bool value) => ref
              .watch(navigationShowInfoButtonsProvider.notifier)
              .state = value,
        );
    log(
      '${FirebaseAuth.instance.currentUser != null}',
      name: '_HealpenWrapperState:didChangeDependencies:currentUserExists',
    );
    log(
      '${ref.watch(OnboardingController().onboardingCompletedProvider)}',
      name: '_HealpenWrapperState:didChangeDependencies:onboardingCompleted',
    );
    super.didChangeDependencies();
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
      if (FirebaseAuth.instance.currentUser == null ||
          ref.watch(OnboardingController().onboardingCompletedProvider)) {
        Iterum.revive(context);
      }
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
          debugShowCheckedModeBanner: false,
          navigatorObservers: [
            ClearFocusNavigatorObserver(),
          ],
          themeMode: themeMode(ref.watch(themeAppearanceProvider)),
          theme: ref.watch(themeProvider),
          initialRoute: switch (FirebaseAuth.instance.currentUser == null &&
              !ref.watch(OnboardingController().onboardingCompletedProvider)) {
            true => '/onboarding',
            false => switch (FirebaseAuth.instance.currentUser != null) {
                true => '/healpen',
                false => '/auth',
              },
          },
          routes: {
            '/onboarding': (context) => const OnboardingView(),
            '/auth': (context) => const AuthView(),
            '/healpen': (context) => const Healpen(),
            '/note': (context) => const NoteView(),
          },
        ),
      ),
    );
  }
}
