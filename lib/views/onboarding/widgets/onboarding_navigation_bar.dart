import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';

import '../../../controllers/onboarding/onboarding_controller.dart';
import '../../../controllers/settings/preferences_controller.dart';
import '../../../utils/constants.dart';
import 'onboarding_button.dart';

class OnboardingNavigationBar extends ConsumerStatefulWidget {
  const OnboardingNavigationBar({super.key});

  @override
  ConsumerState<OnboardingNavigationBar> createState() =>
      _OnboardingNavigationBarState();
}

class _OnboardingNavigationBarState
    extends ConsumerState<OnboardingNavigationBar> {
  void goToAuth() {
    ref
        .watch(OnboardingController().onboardingCompletedProvider.notifier)
        .state = true;
    PreferencesController()
        .onboardingCompleted
        .write(ref.watch(OnboardingController().onboardingCompletedProvider));
    navigator.pushNamed('/auth');
  }

  @override
  Widget build(BuildContext context) {
    int currentPageIndex = ref.watch(
      OnboardingController().currentPageIndexProvider,
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (currentPageIndex == 0)
          OnboardingButton(
            titleString: 'Skip',
            onTap: goToAuth,
          )
        else
          OnboardingButton(
            titleString: 'Back',
            onTap: () {
              ref
                  .watch(OnboardingController().pageControllerProvider)
                  .animateToPage(
                    currentPageIndex - 1,
                    duration: animationDuration.milliseconds,
                    curve: curve,
                  );
            },
          ),
        if (currentPageIndex ==
            OnboardingController().onboardingScreenViews.length - 1)
          OnboardingButton(
            titleString: 'Start Writing Now',
            onTap: goToAuth,
          )
        else
          OnboardingButton(
            titleString: currentPageIndex == 0 ? 'Get Started' : 'Next',
            onTap: () {
              ref
                  .watch(OnboardingController().pageControllerProvider)
                  .animateToPage(
                    currentPageIndex + 1,
                    duration: animationDuration.milliseconds,
                    curve: curve,
                  );
            },
          )
      ],
    );
  }
}
