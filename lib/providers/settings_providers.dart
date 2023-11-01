import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/settings/preferences_controller.dart';
import '../enums/app_theming.dart';

final themeAppearanceProvider = StateProvider<ThemeAppearance>(
  (ref) => PreferencesController.themeAppearance.value,
);

final themeColorProvider = StateProvider<ThemeColor>(
  (ref) => PreferencesController.themeColor.value,
);

/// Whether to reset the stopwatch when the user erases all the text.
/// When set to false, the stopwatch will continue running until the user saves.
/// When set to true, the stopwatch will reset when the user erases all the text.
final writingAutomaticStopwatchProvider = StateProvider<bool>(
  (ref) => PreferencesController.writingAutomaticStopwatch.value,
);

/// Whether to show the analyze notes button in the app.
/// When set to true, the app will show the analyze notes button.
/// When set to false, the app will hide the analyze notes button.
final writingShowAnalyzeNotesButtonProvider = StateProvider<bool>(
  (ref) => PreferencesController.writingShowAnalyzeNotesButton.value,
);

/// Whether to shake the private note info icon when the app starts.
/// When set to true, the device will shake when the user saves a private note.
/// When set to false, the device will not shake when the user saves a private note.
final shakePrivateNoteInfoProvider = StateProvider<bool>(
  (ref) => PreferencesController.shakePrivateNoteInfo.value,
);

/// Whether to show custom navigation buttons in the app.
/// When set to true, the app will show custom navigation buttons.
/// When set to false, the app will show the default navigation buttons.
final navigationShowBackButtonProvider = StateProvider<bool>(
  (ref) => PreferencesController.navigationShowBackButton.value,
);

/// Whether to show info buttons in the app.
/// When set to true, the app will show info buttons.
/// When set to false, the app will hide info buttons.
final navigationShowInfoButtonsProvider = StateProvider<bool>(
  (ref) => PreferencesController.navigationShowInfoButtons.value,
);

/// Whether to reduce the amount of haptic feedback in the app.
/// When set to true, the app will enable haptic feedback.
/// When set to false, the app will disable haptic feedback.
final navigationEnableHapticFeedbackProvider = StateProvider<bool>(
  (ref) => PreferencesController.navigationEnableHapticFeedback.value,
);

/// Whether to hide the app bar title.
/// When set to true, the app bar will be hidden.
/// When set to false, the app bar will be shown.
final navigationShowAppBarProvider = StateProvider<bool>(
  (ref) => PreferencesController.navigationShowAppBar.value,
);

/// Whether to show smaller navigation elements in the app.
/// When set to true, the app will show smaller navigation elements.
/// When set to false, the app will show larger navigation elements.
final navigationSmallerNavigationElementsProvider = StateProvider<bool>(
  (ref) => PreferencesController.navigationSmallerNavigationElements.value,
);
