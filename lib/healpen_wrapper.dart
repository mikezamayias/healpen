import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';

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
    readAppearance(ref);
    readAppColor(ref);
    readShakePrivateNoteInfo(ref);
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
    if (ref.watch(appearanceProvider) == Appearance.system) {
      log(
        '${mediaQuery.platformBrightness}',
        name: '_HealpenWrapperState:didChangePlatformBrightness',
      );
      setState(() {
        getSystemUIOverlayStyle(
          context.theme,
          ref.watch(appearanceProvider),
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
        themeMode: switch (ref.watch(appearanceProvider)) {
          Appearance.system => ThemeMode.system,
          Appearance.light => ThemeMode.light,
          Appearance.dark => ThemeMode.dark,
        },
        theme: createTheme(
          ref.watch(appColorProvider).color,
          switch (ref.watch(appearanceProvider)) {
            Appearance.system =>
              WidgetsBinding.instance.platformDispatcher.platformBrightness,
            Appearance.light => Brightness.light,
            Appearance.dark => Brightness.dark,
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
