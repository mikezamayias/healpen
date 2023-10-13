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
  static final navigationShowInfoButtons = PreferenceModel<bool>(
    'navigationShowInfoButtons',
    true,
  );
  static final navigationEnableHapticFeedback = PreferenceModel<bool>(
    'navigationEnableHapticFeedback',
    true,
  );
  static final onboardingCompleted = PreferenceModel<bool>(
    'onboardingCompleted',
    false,
  );
  static final navigationShowAppBarTitle = PreferenceModel<bool>(
    'navigationShowAppBarTitle',
    true,
  );
  static final writingShowAnalyzeNotesButton = PreferenceModel<bool>(
    'writingShowAnalyzeNotesButton',
    true,
  );

  List<({PreferenceModel preferenceModel})> preferences = [
    (preferenceModel: shakePrivateNoteInfo,),
    (preferenceModel: writingShowAnalyzeNotesButton,),
    (preferenceModel: writingAutomaticStopwatch,),
    (preferenceModel: navigationShowAppBarTitle,),
    (preferenceModel: navigationShowBackButton,),
    (preferenceModel: navigationEnableHapticFeedback,),
    (preferenceModel: onboardingCompleted,),
  ];
}
