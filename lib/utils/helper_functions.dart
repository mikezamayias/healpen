import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';

import '../enums/app_theming.dart';
import '../themes/blueprint_theme.dart';
import '../widgets/custom_list_tile.dart';
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

doAndShowSnackbar(
  BuildContext context, {
  required Future firstDo,
  required thenDo,
  required (String, IconData) snackBarOptions,
}) {
  firstDo.then((value) {
    for (var action in thenDo) {
      action;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        padding: EdgeInsets.only(
          left: gap,
          right: gap,
          bottom: gap,
        ),
        duration: 3.seconds,
        content: CustomListTile(
          backgroundColor: context.theme.colorScheme.secondary,
          textColor: context.theme.colorScheme.onSecondary,
          titleString: snackBarOptions.$1,
          leadingIconData: snackBarOptions.$2,
          contentPadding: EdgeInsets.symmetric(
            vertical: gap,
            horizontal: gap * 2,
          ),
          cornerRadius: radius,
        ),
      ),
    );
  });
}
