import 'package:flutter/material.dart' hide PageController;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';

import '../../../controllers/onboarding/onboarding_controller.dart';
import '../../../controllers/page_controller.dart';
import '../../../providers/settings_providers.dart';
import '../../../utils/constants.dart';
import '../../../utils/helper_functions.dart';
import 'onboarding_button.dart';

class OnboardingNavigationBar extends ConsumerStatefulWidget {
  const OnboardingNavigationBar({super.key});

  @override
  ConsumerState<OnboardingNavigationBar> createState() =>
      _OnboardingNavigationBarState();
}

class _OnboardingNavigationBarState
    extends ConsumerState<OnboardingNavigationBar> {
  void goToAuth() async {
    ref.read(OnboardingController.onboardingCompletedProvider.notifier).state =
        true;
    navigator.pushReplacement(
      PageRouteBuilder(
        transitionDuration: emphasizedDuration,
        reverseTransitionDuration: emphasizedDuration,
        pageBuilder: (context, animation, secondaryAnimation) =>
            PageController().authView.widget,
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(
          opacity: Tween<double>(
            begin: -1,
            end: 1,
          ).animate(animation),
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int currentPageIndex = ref.watch(
      OnboardingController().currentPageIndexProvider,
    );
    int onboardingViewsLength =
        OnboardingController().onboardingScreenViews.length - 1;
    return Padding(
      padding: EdgeInsets.all(gap),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          OnboardingButton(
            titleString: currentPageIndex == 0 ? 'Skip' : 'Back',
            onTap: () {
              if (currentPageIndex == 0) {
                vibrate(
                  ref.watch(navigationEnableHapticFeedbackProvider),
                  goToAuth,
                );
              } else {
                animateToPage(
                  ref.watch(OnboardingController().pageControllerProvider),
                  currentPageIndex - 1,
                );
              }
            },
          ),
          OnboardingButton(
            titleString: currentPageIndex == onboardingViewsLength
                ? 'Start Writing Now'
                : currentPageIndex == 0
                    ? 'Get Started'
                    : 'Next',
            onTap: () {
              if (currentPageIndex == onboardingViewsLength) {
                vibrate(
                  ref.watch(navigationEnableHapticFeedbackProvider),
                  goToAuth,
                );
              } else {
                animateToPage(
                  ref.watch(OnboardingController().pageControllerProvider),
                  currentPageIndex + 1,
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
