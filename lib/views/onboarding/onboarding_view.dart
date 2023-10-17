import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../controllers/onboarding/onboarding_controller.dart';
import '../../controllers/settings/preferences_controller.dart';
import '../../utils/constants.dart';
import '../../utils/helper_functions.dart';
import '../blueprint/blueprint_view.dart';
import 'widgets/onboarding_navigation_bar.dart';

class OnboardingView extends ConsumerWidget {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BlueprintView(
      body: Padding(
        padding: EdgeInsets.only(top: gap),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: PageView.builder(
                clipBehavior: Clip.none,
                controller:
                    ref.read(OnboardingController().pageControllerProvider),
                physics: const BouncingScrollPhysics(),
                itemCount: OnboardingController().onboardingScreenViews.length,
                onPageChanged: (value) {
                  vibrate(
                      PreferencesController
                          .navigationEnableHapticFeedback.value, () {
                    ref
                        .read(OnboardingController()
                            .currentPageIndexProvider
                            .notifier)
                        .state = value;
                  });
                },
                // depending on the current index, animate slide from left or right and opacity
                itemBuilder: (context, index) {
                  final bool active = index ==
                      ref.watch(
                          OnboardingController().currentPageIndexProvider);
                  final double opacity = active ? 1 : 0;
                  final double slide = active
                      ? 0
                      : index <
                              ref.read(OnboardingController()
                                  .currentPageIndexProvider)
                          ? -1
                          : 1;
                  return AnimatedContainer(
                    duration: emphasizedDuration,
                    curve: emphasizedCurve,
                    transform: Matrix4.identity()
                      ..translate(slide * 100.w)
                      ..scale(active ? 1.0 : 0.9),
                    child: AnimatedOpacity(
                      duration: emphasizedDuration,
                      curve: emphasizedCurve,
                      opacity: opacity,
                      child: OnboardingController()
                          .currentOnboardingScreenView(index),
                    ),
                  );
                },
              )
                  .animate()
                  .fade(
                    begin: -1,
                    duration: emphasizedDuration,
                    curve: emphasizedCurve,
                  )
                  .slideY(
                    begin: -0.5,
                    end: 0,
                    duration: emphasizedDuration,
                    curve: emphasizedCurve,
                  ),
            ),
            Padding(
              padding: EdgeInsets.all(gap),
              child: SmoothPageIndicator(
                controller:
                    ref.read(OnboardingController().pageControllerProvider),
                count: OnboardingController().onboardingScreenViews.length,
                effect: ExpandingDotsEffect(
                  activeDotColor: context.theme.colorScheme.primary,
                  dotColor: context.theme.colorScheme.surfaceVariant,
                ),
              )
                  .animate(
                    delay: 1.5.seconds,
                  )
                  .fade(
                    begin: -1,
                    duration: emphasizedDuration,
                    curve: emphasizedCurve,
                  )
                  .slideY(
                    begin: 1,
                    end: 0,
                    duration: emphasizedDuration,
                    curve: emphasizedCurve,
                  ),
            ),
            const OnboardingNavigationBar()
                .animate(
                  delay: 1.seconds,
                )
                .fade(
                  begin: -1,
                  duration: emphasizedDuration,
                  curve: emphasizedCurve,
                )
                .slideY(
                  begin: 1,
                  end: 0,
                  duration: emphasizedDuration,
                  curve: emphasizedCurve,
                ),
          ],
        ),
      ),
    );
  }
}
