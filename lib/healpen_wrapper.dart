import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';

import 'controllers/settings/preferences_controller.dart';
import 'controllers/writing_controller.dart';
import 'enums/app_theming.dart';
import 'healpen.dart';
import 'providers/settings_providers.dart';
import 'utils/helper_functions.dart';
import 'views/auth/auth_view.dart';
import 'views/note/note_view.dart';

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
    PreferencesController().themeAppearance.read().then(
          (ThemeAppearance value) =>
              ref.watch(themeAppearanceProvider.notifier).state = value,
        );
    PreferencesController().themeColor.read().then(
          (ThemeColor value) =>
              ref.watch(themeColorProvider.notifier).state = value,
        );
    PreferencesController().shakePrivateNoteInfo.read().then(
          (bool value) => ref
              .watch(WritingController().shakePrivateNoteInfoProvider.notifier)
              .state = value,
        );
    PreferencesController().writingAutomaticStopwatch.read().then(
          (bool value) => ref
              .watch(writingAutomaticStopwatchProvider.notifier)
              .state = value,
        );
    PreferencesController().navigationBackButton.read().then(
          (bool value) =>
              ref.watch(customNavigationButtonsProvider.notifier).state = value,
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
      child: MaterialApp(
        title: 'Healpen',
        debugShowCheckedModeBanner: false,
        navigatorObservers: [
          ClearFocusNavigatorObserver(),
        ],
        themeMode: switch (ref.watch(themeAppearanceProvider)) {
          ThemeAppearance.system => ThemeMode.system,
          ThemeAppearance.light => ThemeMode.light,
          ThemeAppearance.dark => ThemeMode.dark,
        },
        theme: createTheme(
          ref.watch(themeColorProvider).color,
          switch (ref.watch(themeAppearanceProvider)) {
            ThemeAppearance.system =>
              WidgetsBinding.instance.platformDispatcher.platformBrightness,
            ThemeAppearance.light => Brightness.light,
            ThemeAppearance.dark => Brightness.dark,
          },
        ),
        initialRoute:
            FirebaseAuth.instance.currentUser == null ? '/auth' : '/healpen',
        routes: {
          '/auth': (context) => const AuthView(),
          '/healpen': (context) => const Healpen(),
          '/note': (context) => const NoteView(),
        },
      ),
    );
  }
}
