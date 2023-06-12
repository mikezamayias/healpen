import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'controllers/app_theming_controller.dart';
import 'enums/app_theming.dart';
import 'models/app_theming_model.dart';
import 'providers/page_providers.dart';
import 'utils/helper_functions.dart';
import 'widgets/custom_bottom_navigation_bar.dart';

class Healpen extends ConsumerWidget {
  const Healpen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get the current values from the controllers
    AppColorModel appColorModel =
        ref.watch(AppColorController.instance.appColorControllerProvider);
    AppearanceModel appearanceModel =
        ref.watch(AppearanceController.instance.appearanceControllerProvider);

    // Use the values in your theme
    ThemeData theme = getTheme(
      appColorModel.appColor,
      appearanceModel.appearance == Appearance.dark
          ? Brightness.dark
          : Brightness.light,
    );

    return MaterialApp(
      title: 'Healpen',
      debugShowCheckedModeBanner: false,
      // themeMode: switch (currentAppearance) {
      //   Appearance.system => ThemeMode.system,
      //   Appearance.light => ThemeMode.light,
      //   Appearance.dark => ThemeMode.dark,
      // },
      color: appColorModel.appColor.color,
      theme: theme,
      home: Scaffold(
        body: ref.watch(currentPageProvider).widget,
        bottomNavigationBar: const CustomBottomNavigationBar(),
      ),
    );
  }
}
