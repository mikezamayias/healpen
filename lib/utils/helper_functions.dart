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

void animateToPage(PageController controller, int index) {
  controller.animateToPage(
    index,
    duration: standardDuration,
    curve: standardCurve,
  );
}

void goToPage(PageController controller, int index) {
  controller.jumpToPage(
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
  double closestValue = sentimentValues[0];
  double smallestDifference = (sentiment - closestValue).abs();
  for (double value in sentimentValues) {
    double difference = (sentiment - value).abs();
    if (difference < smallestDifference) {
      closestValue = value;
      smallestDifference = difference;
    }
  }
  int index = sentimentValues.indexOf(closestValue);
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
double getSentimentRatio(dynamic sentiment) {
  return switch (sentiment.runtimeType) {
    const (int) => sentimentValues.indexOf(sentimentValues
            .elementAt(getClosestSentimentIndex(sentiment.toDouble()))) /
        (sentimentValues.length - 1),
    const (double) => sentimentValues.indexOf(
            sentimentValues.elementAt(getClosestSentimentIndex(sentiment))) /
        (sentimentValues.length - 1),
    const (String) =>
      sentimentLabels.indexOf(sentiment) / (sentimentLabels.length - 1),
    _ => throw UnsupportedError(
        'Sentiment value must be of type double or int or String.',
      ),
  };
}

Color getShapeColorOnSentiment(ThemeData theme, dynamic sentiment) {
  return Color.lerp(
    theme.colorScheme.error,
    theme.colorScheme.primary,
    getSentimentRatio(sentiment),
  )!;
}

Color getTextColorOnSentiment(ThemeData theme, dynamic sentiment) {
  return Color.lerp(
    theme.colorScheme.onError,
    theme.colorScheme.onPrimary,
    getSentimentRatio(sentiment),
  )!;
}

/// Checks if the given [score] is close to the specified [value] within a certain deviation.
///
/// Returns `true` if the absolute difference between [score] and [value] is less than the deviation,
/// otherwise returns `false`.
///
/// Example:
/// ```dart
/// double score = 3.5;
/// double value = 3.6;
/// bool isClose = scoreIsCloseToValue(score, value); // Returns true
/// ```
bool scoreIsCloseToValue(double score, double value) {
  const deviation = 0.25;
  return (score - value).abs() < deviation;
}

pushWithAnimation({
  required BuildContext context,
  required Widget widget,
  bool replacement = false,
  required VoidCallback? dataCallback,
}) {
  if (dataCallback != null) {
    dataCallback.call();
  }
  final builder = PageRouteBuilder(
    transitionDuration: emphasizedDuration,
    reverseTransitionDuration: emphasizedDuration,
    pageBuilder: (
      context,
      animation,
      secondaryAnimation,
    ) {
      return widget;
    },
    transitionsBuilder: (
      context,
      animation,
      secondaryAnimation,
      child,
    ) {
      final curvedAnimation = CurvedAnimation(
        parent: animation,
        curve: emphasizedCurve,
        reverseCurve: emphasizedCurve.flipped,
      );
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1, 0),
          end: Offset.zero,
        ).animate(curvedAnimation),
        child: FadeTransition(
          opacity: animation,
          child: child,
        ),
      );
    },
  );
  if (replacement) {
    context.navigator.pushReplacement(builder);
  } else {
    context.navigator.push(builder);
  }
}

pushNamedWithAnimation({
  required BuildContext context,
  required String routeName,
  bool replacement = false,
  Object? arguments,
  required VoidCallback? dataCallback,
}) {
  if (dataCallback != null) {
    dataCallback.call();
  }
  if (replacement) {
    context.navigator.pushReplacementNamed(
      routeName,
      arguments: arguments,
    );
  } else {
    context.navigator.pushNamed(
      routeName,
      arguments: arguments,
    );
  }
}
