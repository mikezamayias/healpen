import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../enums/app_theming.dart';

final appAppearanceProvider = StateProvider<Appearance>(
  (ref) => Appearance.system,
);

final appColorProvider = StateProvider<AppColor>(
  (ref) => AppColor.pastelOcean,
);

/// Whether to reset the stopwatch when the user erases all the text.
/// When set to true, the stopwatch will continue running until the user saves.
/// When set to false, the stopwatch will reset when the user erases all the text.
final writingResetStopwatchOnEmptyProvider = StateProvider<bool>(
  (ref) => true,
);

/// Whether to show custom navigation buttons in the app.
/// When set to true, the app will show custom navigation buttons.
/// When set to false, the app will show the default navigation buttons.
final customNavigationButtonsProvider = StateProvider<bool>(
  (ref) => true,
);