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
  static final showBackButton = PreferenceModel<bool>(
    'showBackButton',
    true,
  );
  static final reduceHapticFeedback = PreferenceModel<bool>(
    'reduceHapticFeedback',
    false,
  );
  static final onboardingCompleted = PreferenceModel<bool>(
    'onboardingCompleted',
    false,
  );
  static final showAppBarTitle = PreferenceModel<bool>(
    'showAppBarTitle',
    true,
  );

  Map<String, dynamic> preferences = {
    shakePrivateNoteInfo.key: shakePrivateNoteInfo.value,
    themeColor.key: themeColor.value,
    themeAppearance.key: themeAppearance.value,
    writingAutomaticStopwatch.key: writingAutomaticStopwatch.value,
    showBackButton.key: showBackButton.value,
    reduceHapticFeedback.key: reduceHapticFeedback.value,
    onboardingCompleted.key: onboardingCompleted.value,
    showAppBarTitle.key: showAppBarTitle.value,
  };

  /// Reset all preferences
  Future<void> resetAll() async {
    preferences.forEach((key, value) async {
      await PreferenceModel(key, value).reset();
    });
  }
}
