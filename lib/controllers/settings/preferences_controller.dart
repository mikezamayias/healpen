import '../../enums/app_theming.dart';
import '../../models/settings/preference_model.dart';

class PreferencesController {
  /// Singleton instance
  static final PreferencesController _instance = PreferencesController._();

  /// A factory constructor that returns the singleton instance.
  factory PreferencesController() => _instance;

  /// Private constructor
  PreferencesController._() {
    _models = [
      shakePrivateNoteInfo,
      themeColor,
      themeAppearance,
      writingAutomaticStopwatch,
      navigationBackButton,
      onboardingCompleted,
    ];
  }

  /// Preference models
  final shakePrivateNoteInfo = PreferenceModel<bool>(
    'shakePrivateNoteInfo',
    true,
  );
  final themeColor = PreferenceModel<ThemeColor>(
    'themeColor',
    ThemeColor.pastelOcean,
  );
  final themeAppearance = PreferenceModel<ThemeAppearance>(
    'themeAppearance',
    ThemeAppearance.system,
  );
  final writingAutomaticStopwatch = PreferenceModel<bool>(
    'writingAutomaticStopwatch',
    false,
  );
  final navigationBackButton = PreferenceModel<bool>(
    'navigationBackButton',
    true,
  );
  final onboardingCompleted = PreferenceModel<bool>(
    'onboardingCompleted',
    false,
  );

  /// List of all preference models
  late List<PreferenceModel> _models;

  /// Read all preferences
  Future<List> readAll() async {
    return [for (PreferenceModel model in _models) await model.read()];
  }

  /// Write all preferences
  Future<void> writeAll() async {
    for (var model in _models) {
      await model.write(model.value);
    }
  }

  /// Reset all preferences
  Future<void> resetAll() async {
    for (var model in _models) {
      await model.write(model.value);
    }
  }
}
