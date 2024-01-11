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

  /// Welcome to Healpen Screen
  static final welcomeScreen = OnboardingModel.builder().copyWith(
    title: 'Welcome to Healpen',
    description:
        'Welcome to Healpen, your personal space for expressive writing and self-discovery. Begin your journey towards better mental health and deeper self-awareness.',
    actionText: 'Next',
  );

  /// Expressive Writing Screen
  static final expressiveWritingScreen = OnboardingModel.builder().copyWith(
    title: 'Expressive Writing',
    description:
        'Healpen harnesses the power of expressive writing. Pour your thoughts and feelings into words, and embark on a path to self-healing and emotional clarity.',
    actionText: 'Continue',
  );

  /// Personalized Insights Screen
  static final personalizedInsightsScreen = OnboardingModel.builder().copyWith(
    title: 'Personalized Insights',
    description:
        'Discover yourself through our advanced sentiment analysis. Healpen provides personalized insights into your emotional patterns, helping you understand your inner world better.',
    actionText: 'Learn More',
  );

  /// Privacy and Safety Screen
  static final privacyAndSafetyScreen = OnboardingModel.builder().copyWith(
    title: 'Privacy and Safety',
    description:
        'Your privacy is our priority. Your entries are securely stored, and our sentiment analysis is done with utmost confidentiality. Feel safe to express yourself freely.',
    actionText: 'Acknowledge',
  );

  /// Begin Your Journey Screen
  static final beginYourJourneyScreen = OnboardingModel.builder().copyWith(
    title: 'Begin Your Journey',
    description:
        'You\'re all set! Start your journey with Healpen today. Reflect, write, and grow as you explore the landscape of your emotions and thoughts.',
    actionText: 'Start Writing',
  );
  final List<OnboardingModel> onboardingScreenModels = [
    welcomeScreen,
    expressiveWritingScreen,
    personalizedInsightsScreen,
    privacyAndSafetyScreen,
    beginYourJourneyScreen,
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
