import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/onboarding/onboarding_model.dart';
import '../../views/onboarding/widgets/onboarding_screen_view.dart';

class OnboardingController {
  /// Singleton constructor
  static final OnboardingController _instance =
      OnboardingController._internal();

  factory OnboardingController() => _instance;

  OnboardingController._internal();

  /// Members
  static bool onboardingCompleted = false;
  final List<OnboardingModel> onboardingScreenModels = [
    // Welcome
    OnboardingModel(
      title: 'Welcome to Healpen',
      description: 'Enhance Your Well-being',
      imagePath: 'assets/images/onboarding/welcome.svg',
    ),
    // Journal
    OnboardingModel(
      title: 'Explore Your Journal',
      description: 'Observe your mood evolve',
      imagePath: 'assets/images/onboarding/journal.svg',
    ),
    // Insights
    OnboardingModel(
      title: 'Gain Insights',
      description: 'Deepen your self-reflection',
      imagePath: 'assets/images/onboarding/insights.svg',
    ),
    // Begin
    OnboardingModel(
      title: 'Begin Your Journey',
      description: 'Start writing today!',
      imagePath: 'assets/images/onboarding/begin.svg',
    ),
  ];

  /// Providers
  static final onboardingCompletedProvider =
      StateProvider<bool>((ref) => false);
  final pageControllerProvider =
      StateProvider<PageController>((ref) => PageController());
  final currentPageIndexProvider = StateProvider<int>((ref) => 0);

  /// Methods

  /// Get [List<OnboardingScreenView>]
  List<OnboardingScreenView> get onboardingScreenViews => [
        for (int index = 0; index < onboardingScreenModels.length; index++)
          _onboardingScreenView(index),
      ];

  /// Get [OnboardingScreenView]
  OnboardingScreenView currentOnboardingScreenView(int currentIndex) =>
      _onboardingScreenView(currentIndex);

  /// Get [OnboardingModel]
  OnboardingModel currentOnboardingScreenModel(int currentIndex) =>
      onboardingScreenModels[currentIndex];

  _onboardingScreenView(int index) => OnboardingScreenView(
        onboardingScreenModel: onboardingScreenModels[index],
      );
}
