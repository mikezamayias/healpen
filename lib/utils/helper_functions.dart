import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:preload_page_view/preload_page_view.dart';

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

void animateToPage(dynamic pageController, int index) {
  assert(
    pageController is PageController || pageController is PreloadPageController,
  );
  pageController.animateToPage(
    index,
    duration: standardDuration,
    curve: standardCurve,
  );
}

void goToPage(dynamic pageController, int index) {
  assert(
    pageController is PageController || pageController is PreloadPageController,
  );
  pageController.jumpToPage(
    index,
  );
}

/// Calculates the combined sentiment value based on the given magnitude and score.
/// The magnitude is normalized to a value between 0 and 1, and then multiplied by the score and 5.
/// The result is returned as a double with 2 decimal places.
///
/// [magnitude] The magnitude of the sentiment.
/// [score] The score of the sentiment.
///
/// Returns
/// [clippedResult] The combined sentiment value as a double with 2 decimal places.
double combinedSentimentValue(double magnitude, double score) {
  // log('$score', name: 'SentenceModel:score');
  // log('$magnitude', name: 'SentenceModel:magnitude');
  double normalizedMagnitude = (magnitude / 2).clamp(0, 1);
  // log('$normalizedMagnitude', name: 'SentenceModel:normalizedMagnitude');
  double result = normalizedMagnitude * score * 5;
  // log('$result', name: 'SentenceModel:result');
  double clippedResult = (result * 100).truncate() / 100;
  // log('$clippedResult', name: 'SentenceModel:clippedResult');
  return clippedResult;
}

int getClosestSentimentIndex(double sentiment) {
  // Round and clamp the sentiment value
  int roundedClampedSentiment = sentiment.round().clamp(-5, 5).toInt();

  // Try to find the index in the sentimentValues list
  int index = sentimentValues.indexOf(roundedClampedSentiment);

  if (index != -1) {
    return index;
  }

  // If the exact index is not found, find the closest one
  index = 0;
  int minDiff = (sentimentValues[0] - roundedClampedSentiment).abs();

  for (int i = 1; i < sentimentValues.length; i++) {
    int diff = (sentimentValues[i] - roundedClampedSentiment).abs();
    if (diff < minDiff) {
      index = i;
      minDiff = diff;
    }
  }

  return index;
}

String getSentimentLabel(double sentiment) {
  int index = getClosestSentimentIndex(sentiment);
  return sentimentLabels[index];
}

IconData getSentimentIcon(double sentiment) {
  int index = getClosestSentimentIndex(sentiment);
  return sentimentIcons[index];
}

/// Get sentiment ratio based on the given sentiment value.
double getSentimentRatio(num sentiment) {
  num minValue = sentimentValues.min;
  num maxValue = sentimentValues.max;
  return double.parse(
    ((sentiment - minValue) / (maxValue - minValue)).toStringAsFixed(2),
  );
}

Color getShapeColorOnSentiment(BuildContext context, double sentiment) {
  return Color.lerp(
    context.theme.colorScheme.error,
    context.theme.colorScheme.primary,
    getSentimentRatio(sentiment),
  )!;
}

Color getTextColorOnSentiment(BuildContext context, double sentiment) {
  return Color.lerp(
    context.theme.colorScheme.onError,
    context.theme.colorScheme.onPrimary,
    getSentimentRatio(sentiment),
  )!;
}
