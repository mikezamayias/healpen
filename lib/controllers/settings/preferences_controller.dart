import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../enums/app_theming.dart';
import '../../models/settings/preference_model.dart';
import '../../providers/settings_providers.dart';
import '../onboarding/onboarding_controller.dart';

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

  // Map<String, dynamic> preferences = {
  //   shakePrivateNoteInfo.key: shakePrivateNoteInfo.value,
  //   writingShowAnalyzeNotesButton.key: writingShowAnalyzeNotesButton.value,
  //   writingAutomaticStopwatch.key: writingAutomaticStopwatch.value,
  //   navigationShowAppBarTitle.key: navigationShowAppBarTitle.value,
  //   navigationShowBackButton.key: navigationShowBackButton.value,
  //   navigationEnableHapticFeedback.key: navigationEnableHapticFeedback.value,
  //   themeColor.key: themeColor.value,
  //   themeAppearance.key: themeAppearance.value,
  //   onboardingCompleted.key: onboardingCompleted.value,
  // };
  List<({PreferenceModel preferenceModel, StateProvider provider})>
      preferences = [
    (
      preferenceModel: shakePrivateNoteInfo,
      provider: shakePrivateNoteInfoProvider
    ),
    (
      preferenceModel: writingShowAnalyzeNotesButton,
      provider: writingShowAnalyzeNotesButtonProvider
    ),
    (
      preferenceModel: writingAutomaticStopwatch,
      provider: writingAutomaticStopwatchProvider
    ),
    (
      preferenceModel: navigationShowAppBarTitle,
      provider: navigationShowAppBarTitleProvider
    ),
    (
      preferenceModel: navigationShowBackButton,
      provider: navigationShowBackButtonProvider
    ),
    (
      preferenceModel: navigationEnableHapticFeedback,
      provider: navigationEnableHapticFeedbackProvider
    ),
    (preferenceModel: themeColor, provider: themeColorProvider),
    (preferenceModel: themeAppearance, provider: themeAppearanceProvider),
    (
      preferenceModel: onboardingCompleted,
      provider: OnboardingController().onboardingCompletedProvider
    ),
  ];

  /// Reset all preferences
  Future<void> resetAll() async {
    for (({PreferenceModel preferenceModel, StateProvider provider}) element
        in preferences) {
      await element.preferenceModel.reset();
      ProviderContainer().read(element.provider).state =
          element.preferenceModel.value;
    }
  }
}
