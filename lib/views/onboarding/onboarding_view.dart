import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';

import '../../controllers/onboarding/onboarding_controller.dart';
import '../../controllers/settings/preferences_controller.dart';
import '../../utils/constants.dart';
import '../blueprint/blueprint_view.dart';
import 'widgets/onboarding_button.dart';
import 'widgets/onboarding_screen_view.dart';

class OnboardingView extends ConsumerStatefulWidget {
  const OnboardingView({super.key});

  @override
  ConsumerState<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends ConsumerState<OnboardingView> {
  late PageController pageController;
  int currentIndex = 0;
  late int tempIndex;
  late OnboardingScreenView currentOnboardingScreenView;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentOnboardingScreenView =
        OnboardingController().currentOnboardingScreenView(currentIndex);
    tempIndex = currentIndex;
    pageController = PageController(
      initialPage: currentIndex,
      keepPage: true,
    )..addListener(() {
        setState(() {
          currentIndex = pageController.page!.round();
          currentOnboardingScreenView =
              OnboardingController().currentOnboardingScreenView(currentIndex);
        });
      });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    pageController.dispose();
  }

  goToAuth() {
    ref
        .watch(OnboardingController().onboardingCompletedProvider.notifier)
        .state = true;
    PreferencesController()
        .onboardingCompleted
        .write(ref.watch(OnboardingController().onboardingCompletedProvider));
    navigator.pushReplacementNamed('/auth');
  }

  @override
  Widget build(BuildContext context) {
    return BlueprintView(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: gap),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: PageView.builder(
                controller: pageController,
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
            ).animate().fade(
                  curve: curve,
                  duration: 1.5.seconds,
                ),
            Column(
              children: [
                ///   Check if the current model is first or last.
                ///   If first, show `skip` and `get started` buttons
                ///   If last, show `back` and `start writing now` buttons
                ///   If neither, show `back` and `next` buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (currentIndex != 0)
                      OnboardingButton(
                        titleString: 'Back',
                        onTap: () {
                          pageController.jumpToPage(currentIndex - 1);
                        },
                      ),
                    if (currentIndex == 0)
                      OnboardingButton(
                        titleString: 'Skip',
                        onTap: goToAuth,
                      ),
                    if (currentIndex ==
                        OnboardingController().onboardingScreenViews.length - 1)
                      OnboardingButton(
                        titleString: 'Start Writing Now',
                        onTap: goToAuth,
                      )
                    else
                      OnboardingButton(
                        titleString: currentIndex == 0 ? 'Get Started' : 'Next',
                        onTap: () {
                          pageController.jumpToPage(currentIndex + 1);
                        },
                      ),
                  ],
                ),
                SizedBox(height: gap * 3),
                DotsIndicator(
                  dotsCount:
                      OnboardingController().onboardingScreenViews.length,
                  position: currentIndex,
                  decorator: DotsDecorator(
                    size: Size.square(gap),
                    activeSize: Size(gap * 2, gap),
                    activeShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(radius),
                    ),
                    spacing: EdgeInsets.symmetric(
                      horizontal: gap / 2,
                    ),
                  ),
                ),
              ]
                  .animate(interval: .5.seconds)
                  .fade(curve: curve, duration: 1.seconds)
                  .slideY(
                    begin: 0.5,
                    end: 0,
                    curve: curve,
                    duration: 1.seconds,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
