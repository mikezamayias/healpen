import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../enums/app_theming.dart';
import '../providers/settings_providers.dart';
import '../themes/blueprint_theme.dart';

SystemUiOverlayStyle getSystemUIOverlayStyle(
    ThemeData theme,
    Appearance appearance,
    ) {
  if (appearance == Appearance.system) {
    return SystemUiOverlayStyle(
      systemNavigationBarColor: theme.colorScheme.background,
      systemNavigationBarDividerColor: theme.colorScheme.background,
      systemNavigationBarIconBrightness:
      theme.brightness.isLight ? Brightness.dark : Brightness.light,
      statusBarColor: Colors.transparent,
      statusBarIconBrightness:
      theme.brightness.isLight ? Brightness.dark : Brightness.light,
    );
  } else if (appearance == Appearance.light) {
    return SystemUiOverlayStyle(
      systemNavigationBarColor: theme.colorScheme.background,
      systemNavigationBarDividerColor: theme.colorScheme.background,
      systemNavigationBarIconBrightness: Brightness.dark,
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    );
  } else {
    return SystemUiOverlayStyle(
      systemNavigationBarColor: theme.colorScheme.background,
      systemNavigationBarDividerColor: theme.colorScheme.background,
      systemNavigationBarIconBrightness: Brightness.light,
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    );
  }
}

ThemeData createTheme(Color color, Brightness brightness) {
  return blueprintTheme(
    ColorScheme.fromSeed(
      seedColor: color,
      brightness: brightness,
    ),
  );
}

ThemeData getTheme(AppColor appColor, Brightness brightness) =>
    switch (appColor) {
      AppColor.blue => createTheme(
          AppColor.blue.color,
          brightness,
        ),
      AppColor.teal => createTheme(
          AppColor.teal.color,
          brightness,
        ),
      AppColor.pastelBlue => createTheme(
          AppColor.pastelBlue.color,
          brightness,
        ),
      AppColor.pastelTeal => createTheme(
          AppColor.pastelTeal.color,
          brightness,
        ),
      AppColor.pastelOcean => createTheme(
          AppColor.pastelOcean.color,
          brightness,
        ),
    };

Future writeAppearance(Appearance appearance) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  log(
    '$appearance',
    name: 'helper_functions.dart:writeAppearance',
  );
  prefs.setString('appearance', '$appearance');
}

Future readAppearance(WidgetRef ref) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? appearance = prefs.getString('appearance');
  log(
    '$appearance',
    name: 'helper_functions.dart:readAppearance',
  );

  if (appearance != null) {
    ref.read(appearanceProvider.notifier).state = Appearance.values.firstWhere(
      (e) => e.toString() == appearance,
    );
  }
}

Future writeAppColor(AppColor appColor) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  log(
    '$appColor',
    name: 'helper_functions.dart:writeAppColor',
  );
  prefs.setString('appColor', '$appColor');
}

Future readAppColor(WidgetRef ref) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? appColor = prefs.getString('appColor');
  log(
    '$appColor',
    name: 'helper_functions.dart:readAppColor',
  );

  if (appColor != null) {
    ref.read(appColorProvider.notifier).state = AppColor.values.firstWhere(
      (e) => e.toString() == appColor,
    );
  }
}
