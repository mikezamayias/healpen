import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../enums/app_theming.dart';
import '../../models/insight_model.dart';
import '../../models/settings/preference_model.dart';
import '../../providers/settings_providers.dart';
import '../insights_controller.dart';
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
  static final navigationShowInfo = PreferenceModel<bool>(
    'navigationShowInfo',
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
  static final navigationShowAppBar = PreferenceModel<bool>(
    'navigationShowAppBar',
    true,
  );
  static final navigationSmallerNavigationElements = PreferenceModel<bool>(
    'navigationSmallerNavigationElements',
    false,
  );
  static final writingShowAnalyzeNotesButton = PreferenceModel<bool>(
    'writingShowAnalyzeNotesButton',
    true,
  );
  static final insightOrder = PreferenceModel<List<String>>(
    'insightOrder',
    InsightsController()
        .insightModelList
        .map((InsightModel element) => element.title)
        .toList(),
  );

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
      preferenceModel: navigationShowAppBar,
      provider: navigationShowAppBarProvider
    ),
    (
      preferenceModel: navigationShowBackButton,
      provider: navigationShowBackButtonProvider
    ),
    (preferenceModel: navigationShowInfo, provider: navigationShowInfoProvider),
    (
      preferenceModel: navigationEnableHapticFeedback,
      provider: navigationEnableHapticFeedbackProvider
    ),
    (
      preferenceModel: navigationSmallerNavigationElements,
      provider: navigationSmallerNavigationElementsProvider
    ),
    (
      preferenceModel: themeColor,
      provider: themeColorProvider,
    ),
    (
      preferenceModel: themeAppearance,
      provider: themeAppearanceProvider,
    ),
    (
      preferenceModel: onboardingCompleted,
      provider: OnboardingController.onboardingCompletedProvider
    ),
    (
      preferenceModel: insightOrder,
      provider: insightsControllerProvider
    )
  ];
}
