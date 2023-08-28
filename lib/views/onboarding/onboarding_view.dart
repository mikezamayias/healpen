import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:sprung/sprung.dart';

import '../../controllers/onboarding/onboarding_controller.dart';
import '../../utils/constants.dart';
import '../blueprint/blueprint_view.dart';
import 'widgets/onboarding_navigation_bar.dart';

class OnboardingView extends ConsumerStatefulWidget {
  const OnboardingView({super.key});

  @override
  ConsumerState<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends ConsumerState<OnboardingView> {
  @override
  Widget build(BuildContext context) {
    ref.watch(OnboardingController().pageControllerProvider).addListener(() {
      ref
              .watch(OnboardingController().currentPageIndexProvider.notifier)
              .state =
          ref
              .watch(OnboardingController().pageControllerProvider)
              .page!
              .round();
    });
    return BlueprintView(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: gap),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: PageView.builder(
                controller:
                    ref.watch(OnboardingController().pageControllerProvider),
                physics: const NeverScrollableScrollPhysics(),
                itemCount: OnboardingController().onboardingScreenViews.length,
                // depending on the current index, animate slide from left or right and opacity
                itemBuilder: (_, int index) => OnboardingController()
                    .currentOnboardingScreenView(index)
                    .animate()
                    .fadeIn(
                      curve: curve,
                      duration: 1.5.seconds,
                    ),
              ),
            )
                .animate()
                .fade(
                  begin: -1,
                  duration: 1.5.seconds,
                  curve: Sprung.overDamped,
                )
                .slideY(
                  begin: -0.5,
                  end: 0,
                  duration: 1.5.seconds,
                  curve: Sprung.overDamped,
                ),
            SmoothPageIndicator(
              controller:
                  ref.watch(OnboardingController().pageControllerProvider),
              count: OnboardingController().onboardingScreenViews.length,
              effect: ExpandingDotsEffect(
                activeDotColor: theme.colorScheme.primary,
                dotColor: theme.colorScheme.surfaceVariant,
              ),
            )
                .animate(
                  delay: 1.5.seconds,
                )
                .fade(
                  begin: -1,
                  duration: 1.5.seconds,
                  curve: Sprung.overDamped,
                )
                .slideY(
                  begin: 1,
                  end: 0,
                  duration: 1.5.seconds,
                  curve: Sprung.overDamped,
                ),
            SizedBox(height: gap * 2),
            const OnboardingNavigationBar()
                .animate(
                  delay: 1.seconds,
                )
                .fade(
                  begin: -1,
                  duration: 1.5.seconds,
                  curve: Sprung.overDamped,
                )
                .slideY(
                  begin: 1,
                  end: 0,
                  duration: 1.5.seconds,
                  curve: Sprung.overDamped,
                ),
          ],
        ),
      ),
    );
  }
}
