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
  static final accountAnalyticsEnabled = PreferenceModel<bool>(
    'analyticsEnabled',
    false,
  );
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
  static final themeColorizeOnSentiment = PreferenceModel<bool>(
    'themeColorizeOnSentiment',
    false,
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
    List.from(
      InsightsController()
          .insightModelList
          .map((InsightModel element) => element.title),
    ),
  );

  List<({PreferenceModel preferenceModel, StateProvider provider, bool log})>
      preferences = [
    (
      preferenceModel: accountAnalyticsEnabled,
      provider: accountAnalyticsEnabledProvider,
      log: false,
    ),
    (
      preferenceModel: shakePrivateNoteInfo,
      provider: shakePrivateNoteInfoProvider,
      log: false,
    ),
    (
      preferenceModel: writingShowAnalyzeNotesButton,
      provider: writingShowAnalyzeNotesButtonProvider,
      log: false,
    ),
    (
      preferenceModel: writingAutomaticStopwatch,
      provider: writingAutomaticStopwatchProvider,
      log: false,
    ),
    (
      preferenceModel: navigationShowAppBar,
      provider: navigationShowAppBarProvider,
      log: false,
    ),
    (
      preferenceModel: navigationShowBackButton,
      provider: navigationShowBackButtonProvider,
      log: false,
    ),
    (
      preferenceModel: navigationShowInfo,
      provider: navigationShowInfoProvider,
      log: false,
    ),
    (
      preferenceModel: navigationEnableHapticFeedback,
      provider: navigationEnableHapticFeedbackProvider,
      log: false,
    ),
    (
      preferenceModel: navigationSmallerNavigationElements,
      provider: navigationSmallerNavigationElementsProvider,
      log: false,
    ),
    (
      preferenceModel: themeColor,
      provider: themeColorProvider,
      log: false,
    ),
    (
      preferenceModel: themeAppearance,
      provider: themeAppearanceProvider,
      log: false,
    ),
    (
      preferenceModel: onboardingCompleted,
      provider: OnboardingController.onboardingCompletedProvider,
      log: false,
    ),
    (
      preferenceModel: insightOrder,
      provider: insightsControllerProvider,
      log: false,
    ),
  ];
}
