import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'enums/app_theming.dart';
import 'healpen.dart';
import 'providers/settings_providers.dart';
import 'utils/helper_functions.dart';
import 'views/auth/auth_view.dart';

class HealpenWrapper extends ConsumerStatefulWidget {
  const HealpenWrapper({Key? key}) : super(key: key);

  @override
  ConsumerState<HealpenWrapper> createState() => _HealpenWrapperState();
}

class _HealpenWrapperState extends ConsumerState<HealpenWrapper>
    with WidgetsBindingObserver {
  late WidgetsBinding _widgetsBinding;

  @override
  void initState() {
    readAppearance(ref);
    readAppColor(ref);
    _widgetsBinding = WidgetsBinding.instance;
    _widgetsBinding.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Healpen',
      debugShowCheckedModeBanner: false,
      theme: createTheme(
        ref.watch(appColorProvider).color,
        _widgetsBinding.platformDispatcher.platformBrightness,
      ),
      themeMode: switch (ref.watch(appearanceProvider)) {
        Appearance.system => ThemeMode.system,
        Appearance.light => ThemeMode.light,
        Appearance.dark => ThemeMode.dark,
      },
      initialRoute:
          FirebaseAuth.instance.currentUser == null ? '/auth' : '/healpen',
      routes: {
        '/auth': (context) => const AuthView(),
        '/healpen': (context) => const Healpen()
      },
    );
  }

  @override
  void didChangePlatformBrightness() {
    log(
      _widgetsBinding.platformDispatcher.platformBrightness.toString(),
      name: '_HealpenWrapperState:didChangePlatformBrightness',
    );
    setState(() {});
  }
}
