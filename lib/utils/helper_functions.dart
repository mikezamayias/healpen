import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../enums/app_theming.dart';
import '../themes/blueprint_theme.dart';

SystemUiOverlayStyle getSystemUIOverlayStyle(
  ThemeData theme,
  Appearance appearance,
) {
  if (Platform.isAndroid) {
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
    } else {
      if (appearance == Appearance.light) {
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
  } else {
    return switch (appearance) {
      Appearance.system =>
        WidgetsBinding.instance.platformDispatcher.platformBrightness.isLight
            ? SystemUiOverlayStyle.dark
            : SystemUiOverlayStyle.light,
      Appearance.light => SystemUiOverlayStyle.dark,
      Appearance.dark => SystemUiOverlayStyle.light,
    };
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

Future writeAppearance(Appearance appearance) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  log(
    '$appearance',
    name: 'helper_functions.dart:writeAppearance',
  );
  prefs.setString('appearance', '$appearance');
}

Future<Appearance> readAppearance() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? appearance = prefs.getString('appearance');
  log(
    '$appearance',
    name: 'helper_functions.dart:readAppearance',
  );
  return Appearance.values.firstWhere(
    (e) => e.toString() == appearance,
  );
}

Future writeAppColor(AppColor appColor) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  log(
    '$appColor',
    name: 'helper_functions.dart:writeAppColor',
  );
  prefs.setString('appColor', '$appColor');
}

Future<AppColor> readAppColor() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? appColor = prefs.getString('appColor');
  log(
    '$appColor',
    name: 'helper_functions.dart:readAppColor',
  );
  return AppColor.values.firstWhere(
    (e) => e.toString() == appColor,
  );
}

Future writeShakePrivateNoteInfo(bool shakePrivateNoteInfo) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  log(
    '$shakePrivateNoteInfo',
    name: 'helper_functions.dart:writeShakePrivateNoteInfo',
  );
  prefs.setBool('shakePrivateNoteInfo', shakePrivateNoteInfo);
}

Future<bool> readShakePrivateNoteInfo() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool shakePrivateNoteInfo = prefs.getBool('shakePrivateNoteInfo') ?? true;
  log(
    '$shakePrivateNoteInfo',
    name: 'helper_functions.dart:readShakePrivateNoteInfo',
  );
  return shakePrivateNoteInfo;
}

Future writeWritingResetStopwatchOnEmpty(
  bool writingResetStopwatchOnEmpty,
) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  log(
    '$writingResetStopwatchOnEmpty',
    name: 'helper_functions.dart:writeWritingResetStopwatchOnEmpty',
  );
  prefs.setBool('writingResetStopwatchOnEmpty', writingResetStopwatchOnEmpty);
}

Future<bool> readWritingResetStopwatchOnEmpty() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool writingResetStopwatchOnEmpty = prefs.getBool(
        'writingResetStopwatchOnEmpty',
      ) ??
      false;
  log(
    '$writingResetStopwatchOnEmpty',
    name: 'helper_functions.dart:readWritingResetStopwatchOnEmpty',
  );
  return writingResetStopwatchOnEmpty;
}

Future writeCustomNavigationButtons(bool customNavigationButtons) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  log(
    '$customNavigationButtons',
    name: 'helper_functions.dart:writeCustomNavigationButtons',
  );
  prefs.setBool('customNavigationButtons', customNavigationButtons);
}

Future<bool> readCustomNavigationButtons() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool customNavigationButtons = prefs.getBool('customNavigationButtons') ?? true;
  log(
    '$customNavigationButtons',
    name: 'helper_functions.dart:readCustomNavigationButtons',
  );
  return customNavigationButtons;
}