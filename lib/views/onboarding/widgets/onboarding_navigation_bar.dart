import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';

import '../../../controllers/onboarding/onboarding_controller.dart';
import '../../../controllers/settings/preferences_controller.dart';
import '../../../providers/settings_providers.dart';
import '../../../utils/constants.dart';
import '../../../utils/helper_functions.dart';
import '../../auth/auth_view.dart';
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
    ref.watch(OnboardingController().pageControllerProvider).dispose();
    ref
        .watch(OnboardingController().onboardingCompletedProvider.notifier)
        .state = true;
    PreferencesController.onboardingCompleted
        .write(ref.watch(OnboardingController().onboardingCompletedProvider));
    navigator.pushReplacement(
      PageRouteBuilder(
        transitionDuration: emphasizedDuration,
        reverseTransitionDuration: emphasizedDuration,
        pageBuilder: (context, animation, secondaryAnimation) =>
            const AuthView(),
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

  void goToPage(int index) {
    ref.watch(OnboardingController().pageControllerProvider).animateToPage(
          index,
          duration: emphasizedDuration,
          curve: emphasizedCurve,
        );
  }

  @override
  Widget build(BuildContext context) {
    int currentPageIndex = ref.watch(
      OnboardingController().currentPageIndexProvider,
    );
    return Padding(
      padding: EdgeInsets.all(gap),
      child: AnimatedSwitcher(
        duration: emphasizedDuration,
        reverseDuration: standardDuration,
        switchInCurve: standardCurve,
        switchOutCurve: standardCurve,
        transitionBuilder: (child, animation) => FadeTransition(
          opacity: animation,
          child: child,
        ),
        child: Row(
          key: currentPageIndex == 0 ||
                  currentPageIndex ==
                      OnboardingController().onboardingScreenViews.length - 1
              ? ValueKey<int>(currentPageIndex)
              : null,
          // Key ensures a new widget is detected
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (currentPageIndex == 0) ...[
              OnboardingButton(
                titleString: 'Skip',
                onTap: () {
                  vibrate(ref.watch(navigationReduceHapticFeedbackProvider),
                      () {
                    goToAuth();
                  });
                },
              ),
              OnboardingButton(
                titleString: 'Get Started',
                onTap: () {
                  goToPage(currentPageIndex + 1);
                },
              ),
            ] else if (currentPageIndex ==
                OnboardingController().onboardingScreenViews.length - 1) ...[
              OnboardingButton(
                titleString: 'Back',
                onTap: () {
                  goToPage(currentPageIndex - 1);
                },
              ),
              OnboardingButton(
                titleString: 'Start Writing Now',
                onTap: () {
                  vibrate(ref.watch(navigationReduceHapticFeedbackProvider),
                      () {
                    goToAuth();
                  });
                },
              ),
            ] else ...[
              OnboardingButton(
                titleString: 'Back',
                onTap: () {
                  goToPage(currentPageIndex - 1);
                },
              ),
              OnboardingButton(
                titleString: 'Next',
                onTap: () {
                  goToPage(currentPageIndex + 1);
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}
