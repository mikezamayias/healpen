import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../enums/app_theming.dart';

final themeAppearanceProvider = StateProvider<ThemeAppearance>(
  (ref) => ThemeAppearance.system,
);

final themeColorProvider = StateProvider<ThemeColor>(
  (ref) => ThemeColor.pastelOcean,
);

/// Whether to reset the stopwatch when the user erases all the text.
/// When set to false, the stopwatch will continue running until the user saves.
/// When set to true, the stopwatch will reset when the user erases all the text.
final writingAutomaticStopwatchProvider = StateProvider<bool>(
  (ref) => false,
);

/// Whether to show custom navigation buttons in the app.
/// When set to true, the app will show custom navigation buttons.
/// When set to false, the app will show the default navigation buttons.
final customNavigationButtonsProvider = StateProvider<bool>(
  (ref) => true,
);