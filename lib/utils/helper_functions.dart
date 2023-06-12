import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../enums/app_theming.dart';
import '../themes/blueprint_theme.dart';

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
  prefs.setString('appearance', '$appearance');
  log(
    '$appearance',
    name: 'helper_functions.dart:appearance',
  );
}

Future readAppearance(Appearance appearance) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? value = prefs.getString('appearance');
  if (value != null) {
    appearance = Appearance.values.firstWhere(
      (e) => e.toString() == value,
    );
  }
  log(
    value ?? 'null',
    name: 'helper_functions.dart:readAppearance',
  );
}

Future writeColor(AppColor appColor) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('color', '$appColor');
  log(
    '$appColor',
    name: 'helper_functions.dart:writeColor',
  );
}

Future readColor(AppColor appColor) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? value = prefs.getString('color');
  if (value != null) {
    appColor = AppColor.values.firstWhere(
      (e) => e.toString() == value,
    );
  }
  log(
    value ?? 'null',
    name: 'helper_functions.dart:readColor',
  );
}
