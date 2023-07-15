import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  late ThemeData theme;

  @override
  void initState() {
    readAppearance(ref);
    readAppColor(ref);
    WidgetsBinding.instance.addObserver(this);
    theme = createTheme(
      ref.read(appColorProvider.notifier).state.color,
      WidgetsBinding.instance.platformDispatcher.platformBrightness,
    );
    updateSystemBarStyles();
    super.initState();
  }

  void updateSystemBarStyles() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: theme.colorScheme.background,
      statusBarColor: theme.colorScheme.background,
      statusBarBrightness: theme.colorScheme.background.isLight
          ? Brightness.dark
          : Brightness.light,
      statusBarIconBrightness: theme.colorScheme.background.isLight
          ? Brightness.dark
          : Brightness.light,
      systemNavigationBarIconBrightness: theme.colorScheme.background.isLight
          ? Brightness.dark
          : Brightness.light,
    ));
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    log(
      WidgetsBinding.instance.platformDispatcher.platformBrightness.toString(),
      name: '_HealpenWrapperState:didChangePlatformBrightness',
    );
    theme = createTheme(
      ref.read(appColorProvider.notifier).state.color,
      WidgetsBinding.instance.platformDispatcher.platformBrightness,
    );
    setState(() {
      updateSystemBarStyles();
    });
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
        theme: theme,
        themeMode: switch (ref.watch(appearanceProvider)) {
          Appearance.system => ThemeMode.system,
          Appearance.light => ThemeMode.light,
          Appearance.dark => ThemeMode.dark,
        },
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
