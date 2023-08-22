import 'dart:developer';

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
  final List<OnboardingModel> onboardingScreenModels = [
    // 1
    OnboardingModel(
      title: 'Welcome to Healpen',
      description: 'Connect with Yourself & Enhance Your Well-being',
      imagePath: 'assets/images/onboarding/screen_1.svg',
    ),
    // 2
    OnboardingModel(
      title: 'Embrace Expressive Writing',
      description:
          'Discover the positive impact of expressive writing on your well-being: relieve stress, reduce anxiety, enhance self-awareness, and promote emotional healing.',
      imagePath: 'assets/images/onboarding/screen_2.svg',
    ),
    // 3
    OnboardingModel(
      title: 'Give Shape to Your Emotions',
      description:
          'Effortlessly convert your thoughts and emotions into words using our user-friendly text editor.',
      imagePath: 'assets/images/onboarding/screen_3.svg',
    ),
    // 4
    OnboardingModel(
      title: 'Gain Valuable Insights',
      description:
          'Discover valuable understanding and analysis to deepen your self-reflection on your expressive journey.',
      imagePath: 'assets/images/onboarding/screen_4.svg',
    ),
    // 5
    OnboardingModel(
      title: 'Explore Your Expressive Journal',
      description:
          'Take a journey through your past expressions and witness the evolution of your thoughts and emotions over time.',
      imagePath: 'assets/images/onboarding/screen_5.svg',
    ),
    // 6
    OnboardingModel(
      title: 'Ready to Begin Your Journey?',
      description: 'Start your expressive writing journey today!',
      imagePath: 'assets/images/onboarding/screen_6.svg',
    ),
  ];
  final onboardingCompletedProvider = StateProvider<bool>((ref) {
    return false;
  });

  /// Methods

  /// Get [List<OnboardingScreenView>]
  List<OnboardingScreenView> get onboardingScreenViews => [
        for (int index = 0; index < onboardingScreenModels.length; index++)
          _onboardingScreenView(index),
      ];

  /// Get [OnboardingScreenView]
  OnboardingScreenView currentOnboardingScreenView(int currentIndex) {
    log(
      '$currentIndex',
      name: 'OnboardingScreenController:currentOnboardingScreenView',
    );
    return _onboardingScreenView(currentIndex);
  }

  _onboardingScreenView(int index) => OnboardingScreenView(
        onboardingScreenModel: onboardingScreenModels[index],
      );
}
