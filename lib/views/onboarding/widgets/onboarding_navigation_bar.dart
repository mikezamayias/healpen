import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';

import '../../../controllers/onboarding/onboarding_controller.dart';
import '../../../controllers/settings/preferences_controller.dart';
import '../../../utils/constants.dart';
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
    HapticFeedback.vibrate().whenComplete(() {
      ref
          .watch(OnboardingController().onboardingCompletedProvider.notifier)
          .state = true;
      PreferencesController()
          .onboardingCompleted
          .write(ref.watch(OnboardingController().onboardingCompletedProvider));
      navigator.push(
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
    });
  }

  void goToPage(int index) {
    HapticFeedback.vibrate().whenComplete(() {
      ref.watch(OnboardingController().pageControllerProvider).animateToPage(
            index,
            duration: emphasizedDuration,
            curve: emphasizedCurve,
          );
    });
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
                onTap: goToAuth,
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
                onTap: goToAuth,
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

    // return Row(
    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //   children: [
    //     // First Button CrossFade (Skip <-> Back)
    //     ClipRRect(
    //       borderRadius: BorderRadius.circular(radius),
    //       child: AnimatedCrossFade(
    //         duration: 50.milliseconds,
    //         reverseDuration: 50.milliseconds,
    //         sizeCurve: standardCurve,
    //         firstCurve: standardCurve,
    //         secondCurve: standardCurve,
    //         firstChild: OnboardingButton(
    //           titleString: 'Skip',
    //           onTap: goToAuth,
    //         ),
    //         secondChild: OnboardingButton(
    //           titleString: 'Back',
    //           onTap: () {
    //             goToPage(currentPageIndex - 1);
    //           },
    //         ),
    //         crossFadeState: currentPageIndex == 0
    //             ? CrossFadeState.showFirst
    //             : CrossFadeState.showSecond,
    //       ),
    //     ),
    //
    //     // Second Button CrossFade
    //     ClipRRect(
    //       borderRadius: BorderRadius.circular(radius),
    //       child: AnimatedCrossFade(
    //         duration: 50.milliseconds,
    //         reverseDuration: 50.milliseconds,
    //         sizeCurve: standardCurve,
    //         firstCurve: standardCurve,
    //         secondCurve: standardCurve,
    //         firstChild: OnboardingButton(
    //           titleString: 'Get Started',
    //           onTap: () {
    //             goToPage(currentPageIndex + 1);
    //           },
    //         ),
    //         secondChild: ClipRRect(
    //           borderRadius: BorderRadius.circular(radius),
    //           child: AnimatedCrossFade(
    //             duration: 50.milliseconds,
    //             reverseDuration: 50.milliseconds,
    //             sizeCurve: standardCurve,
    //             firstCurve: standardCurve,
    //             secondCurve: standardCurve,
    //             firstChild: OnboardingButton(
    //               titleString: 'Next',
    //               onTap: () {
    //                 goToPage(currentPageIndex + 1);
    //               },
    //             ),
    //             secondChild: OnboardingButton(
    //               titleString: 'Start Writing Now',
    //               onTap: goToAuth,
    //             ),
    //             crossFadeState: currentPageIndex ==
    //                     OnboardingController().onboardingScreenViews.length - 1
    //                 ? CrossFadeState.showSecond
    //                 : CrossFadeState.showFirst,
    //           ),
    //         ),
    //         crossFadeState: currentPageIndex == 0
    //             ? CrossFadeState.showFirst
    //             : CrossFadeState.showSecond,
    //       ),
    //     ),
    //   ],
    // );
  }
}
