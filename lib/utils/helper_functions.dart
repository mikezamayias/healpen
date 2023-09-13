import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';

import '../enums/app_theming.dart';
import '../themes/blueprint_theme.dart';
import 'constants.dart';

SystemUiOverlayStyle getSystemUIOverlayStyle(
  ThemeData theme,
  ThemeAppearance appearance,
) {
  if (Platform.isAndroid) {
    if (appearance == ThemeAppearance.system) {
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
      if (appearance == ThemeAppearance.light) {
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
      ThemeAppearance.system =>
        WidgetsBinding.instance.platformDispatcher.platformBrightness.isLight
            ? SystemUiOverlayStyle.dark
            : SystemUiOverlayStyle.light,
      ThemeAppearance.light => SystemUiOverlayStyle.dark,
      ThemeAppearance.dark => SystemUiOverlayStyle.light,
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

Brightness brightness(ThemeAppearance themeAppearance) {
  return switch (themeAppearance) {
    ThemeAppearance.system =>
      WidgetsBinding.instance.platformDispatcher.platformBrightness,
    ThemeAppearance.light => Brightness.light,
    ThemeAppearance.dark => Brightness.dark,
  };
}

ThemeMode themeMode(ThemeAppearance themeAppearance) {
  return switch (themeAppearance) {
    ThemeAppearance.system => ThemeMode.system,
    ThemeAppearance.light => ThemeMode.light,
    ThemeAppearance.dark => ThemeMode.dark,
  };
}

void vibrate(bool reduceHapticFeedback, VoidCallback callback) {
  if (!reduceHapticFeedback) {
    HapticFeedback.lightImpact().whenComplete(() {
      callback();
    });
  } else {
    callback();
  }
}

void animateToPage(PageController pageController, int index) {
  pageController.animateToPage(
    index,
    duration: emphasizedDuration,
    curve: emphasizedCurve,
  );
}

void goToPage(PageController pageController, int index) {
  pageController.jumpToPage(
    index,
  );
}
