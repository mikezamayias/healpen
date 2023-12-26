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
      description:
          'Healpen helps you reflect on your thoughts and feelings through expressive writing.',
    ),

    // Expressive Writing
    OnboardingModel(
      title: 'Expressive Writing',
      description:
          'Expressive writing involves writing about your deepest thoughts and feelings. This can help you gain insight and improve your mental health.',
    ),

    // Insights
    OnboardingModel(
      title: 'Gain Insights',
      description:
          'Expressive writing can lead to insights about your emotional patterns through advanced analysis of your texts.',
    ),

    // Begin
    OnboardingModel(
        title: 'Begin Your Journey',
        description:
            'Start writing in Healpen today to begin reflecting on your inner thoughts and emotions.'),
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

  OnboardingScreenView _onboardingScreenView(int index) => OnboardingScreenView(
        onboardingScreenModel: onboardingScreenModels[index],
      );
}
