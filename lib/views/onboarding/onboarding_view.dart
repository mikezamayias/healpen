import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart' hide SlideEffect;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../controllers/onboarding/onboarding_controller.dart';
import '../../controllers/page_controller.dart' as page_controller;
import '../../providers/settings_providers.dart';
import '../../utils/constants.dart';
import '../../utils/helper_functions.dart';
import '../blueprint/blueprint_view.dart';
import 'widgets/onboarding_button.dart';

class OnboardingView extends ConsumerStatefulWidget {
  const OnboardingView({super.key});

  @override
  ConsumerState<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends ConsumerState<OnboardingView> {
  late PageController pageController;
  double viewPortFraction = 0.87;
  double pageOffset = 0;

  @override
  void initState() {
    pageController = PageController(
      viewportFraction: viewPortFraction,
    )..addListener(() {
        setState(() {
          pageOffset = pageController.page!;
        });
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlueprintView(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 66.h,
            child: PageView.builder(
              clipBehavior: Clip.none,
              controller: pageController,
              physics: const ClampingScrollPhysics(),
              itemCount: OnboardingController().onboardingScreenViews.length,
              onPageChanged: (int index) {
                vibrate(ref.watch(navigationEnableHapticFeedbackProvider), () {
                  animateToPage(pageController, index);
                  ref
                      .read(OnboardingController()
                          .currentPageIndexProvider
                          .notifier)
                      .state = index;
                });
              },
              itemBuilder: (context, index) {
                double scale = max(viewPortFraction,
                    (1 - (pageOffset - index).abs()) + viewPortFraction);
                double angle = (pageOffset - index).abs();
                if (angle > 0.5) {
                  angle = 1 - angle;
                }
                return AnimatedContainer(
                  duration: standardDuration,
                  curve: standardCurve,
                  margin: EdgeInsets.symmetric(
                    vertical: gap * scale,
                    horizontal: gap,
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: 100 - scale * 50,
                  ),
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..rotateY(angle),
                  alignment: Alignment.center,
                  child:
                      OnboardingController().currentOnboardingScreenView(index),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(gap),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SmoothPageIndicator(
                  controller: pageController,
                  count: OnboardingController().onboardingScreenViews.length,
                  effect: ExpandingDotsEffect(
                    dotColor: context.theme.colorScheme.surfaceVariant,
                    activeDotColor: context.theme.colorScheme.primary,
                  ),
                ),
                OnboardingButton(
                  titleString: 'Start Writing Now',
                  onTap: () => goToAuth(context, ref),
                ),
              ],
            )
                .animate()
                .fade(
                  begin: -1,
                  duration: standardDuration,
                  curve: standardCurve,
                )
                .slideY(
                  begin: 1,
                  end: 0,
                  duration: standardDuration,
                  curve: standardCurve,
                ),
          ),
        ],
      ),
    );
  }

  void goToAuth(BuildContext context, WidgetRef ref) async {
    ref.read(OnboardingController.onboardingCompletedProvider.notifier).state =
        true;
    context.navigator.pushReplacement(
      PageRouteBuilder(
        transitionDuration: emphasizedDuration,
        reverseTransitionDuration: emphasizedDuration,
        pageBuilder: (context, animation, secondaryAnimation) =>
            page_controller.PageController().authView.widget,
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
}
