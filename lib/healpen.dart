import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';

import 'enums/app_theming.dart';
import 'providers/page_providers.dart';
import 'providers/settings_providers.dart';
import 'utils/helper_functions.dart';
import 'widgets/custom_bottom_navigation_bar.dart';

class Healpen extends ConsumerWidget {
  const Healpen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    log(
      context.theme.scaffoldBackgroundColor.toString(),
      name: 'scaffoldBackgroundColor',
    );
    log(
      context.theme.colorScheme.background.toString(),
      name: 'colorScheme.background',
    );
    return MaterialApp(
      title: 'Healpen',
      debugShowCheckedModeBanner: false,
      themeMode: switch (ref.watch(appearanceProvider)) {
        Appearance.system => ThemeMode.system,
        Appearance.light => ThemeMode.light,
        Appearance.dark => ThemeMode.dark,
      },
      color: ref.watch(currentAppColorProvider).color,
      theme: getTheme(ref.watch(currentAppColorProvider), Brightness.light),
      darkTheme: getTheme(ref.watch(currentAppColorProvider), Brightness.dark),
      home: Scaffold(
        body: ref.watch(currentPageProvider).widget,
        bottomNavigationBar: const CustomBottomNavigationBar(),
      ),
    );
  }
}
