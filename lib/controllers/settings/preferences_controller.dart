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
      appColor,
      appAppearance,
      writingAutomaticStopwatch,
      navigationBackButton,
    ];
  }

  /// Preference models
  final shakePrivateNoteInfo =
      PreferenceModel<bool>('shakePrivateNoteInfo', true);
  final appColor =
      PreferenceModel<String>('appColor', AppColor.pastelOcean.toString());
  final appAppearance =
      PreferenceModel<String>('appAppearance', Appearance.system.toString());
  final writingAutomaticStopwatch =
      PreferenceModel<bool>('writingAutomaticStopwatch', false);
  final navigationBackButton =
      PreferenceModel<bool>('navigationBackButton', true);

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
