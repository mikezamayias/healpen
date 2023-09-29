import '../../enums/app_theming.dart';
import '../../models/settings/preference_model.dart';

class PreferencesController {
  /// Singleton instance
  static final PreferencesController _instance = PreferencesController._();

  /// A factory constructor that returns the singleton instance.
  factory PreferencesController() => _instance;

  /// Private constructor
  PreferencesController._();

  /// Preference models
  static final shakePrivateNoteInfo = PreferenceModel<bool>(
    'shakePrivateNoteInfo',
    true,
  );
  static final themeColor = PreferenceModel<ThemeColor>(
    'themeColor',
    ThemeColor.teal,
  );
  static final themeAppearance = PreferenceModel<ThemeAppearance>(
    'themeAppearance',
    ThemeAppearance.system,
  );
  static final writingAutomaticStopwatch = PreferenceModel<bool>(
    'writingAutomaticStopwatch',
    false,
  );
  static final navigationShowBackButton = PreferenceModel<bool>(
    'navigationShowBackButton',
    true,
  );
  static final navigationReduceHapticFeedback = PreferenceModel<bool>(
    'navigationReduceHapticFeedback',
    false,
  );
  static final onboardingCompleted = PreferenceModel<bool>(
    'onboardingCompleted',
    false,
  );
  static final navigationShowAppBarTitle = PreferenceModel<bool>(
    'navigationShowAppBarTitle',
    true,
  );
  static final showAnalyzeNotesButton = PreferenceModel<bool>(
    'showAnalyzeNotesButton',
    true,
  );

  Map<String, dynamic> preferences = {
    shakePrivateNoteInfo.key: shakePrivateNoteInfo.value,
    showAnalyzeNotesButton.key: showAnalyzeNotesButton.value,
    writingAutomaticStopwatch.key: writingAutomaticStopwatch.value,
    navigationShowAppBarTitle.key: navigationShowAppBarTitle.value,
    navigationShowBackButton.key: navigationShowBackButton.value,
    navigationReduceHapticFeedback.key: navigationReduceHapticFeedback.value,
    themeColor.key: themeColor.value,
    themeAppearance.key: themeAppearance.value,
    onboardingCompleted.key: onboardingCompleted.value,
  };

  /// Reset all preferences
  Future<void> resetAll() async {
    preferences.forEach((key, value) async {
      await PreferenceModel(key, value).reset();
    });
  }
}
