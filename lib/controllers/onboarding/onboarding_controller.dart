import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../views/onboarding/views/crashlytics_view.dart';
import '../../views/onboarding/views/begin_your_journey_view.dart';
import '../../views/onboarding/views/expressive_writing_view.dart';
import '../../views/onboarding/views/personalized_insights_view.dart';
import '../../views/onboarding/views/privacy_and_safety_view.dart';
import '../../views/onboarding/views/welcome_view.dart';

class OnboardingController {
  /// Singleton constructor
  static final OnboardingController _instance =
      OnboardingController._internal();

  factory OnboardingController() => _instance;

  OnboardingController._internal();

  /// Members
  static bool onboardingCompleted = false;
  static const views = <Widget>[
    OnboardingWelcomeView(),
    OnboardingExpressiveWritingView(),
    OnboardingPersonalizedInsightsView(),
    OnboardingPivacyAndSafetyView(),
    OnboardingCrashlyticsView(),
    OnboardingBeginYourJourneyView(),
  ];

  /// Providers
  static final onboardingCompletedProvider =
      StateProvider<bool>((ref) => false);
  final pageControllerProvider =
      StateProvider<PageController>((ref) => PageController());
  final currentPageIndexProvider = StateProvider<int>((ref) => 0);
}
