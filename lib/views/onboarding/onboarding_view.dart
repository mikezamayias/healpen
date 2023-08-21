import 'dart:developer';

import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../controllers/onboarding/onboarding_controller.dart';
import '../../models/onboarding/onboarding_model.dart';
import '../../utils/constants.dart';
import '../blueprint/blueprint_view.dart';
import 'widgets/onboarding_button.dart';
import 'widgets/onboarding_screen_view.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
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
    pageController = PageController(
      initialPage: currentIndex,
      keepPage: true,
    )..addListener(() {
        setState(() {
          currentIndex = pageController.page!.round();
          tempIndex = currentIndex - 1;
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
                        duration: 1.seconds,
                      ),
              ),
            ),

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
                  ).animate().fade(
                        curve: curve,
                        duration: 1.seconds,
                      ),
                if (currentIndex == 0)
                  const OnboardingButton(
                    titleString: 'Skip',
                  ).animate().fade(
                        curve: curve,
                        duration: 1.seconds,
                      ),
                if (currentIndex ==
                    OnboardingController().onboardingScreenViews.length - 1)
                  const OnboardingButton(
                    titleString: 'Start Writing Now',
                  ).animate().fade(
                        curve: curve,
                        duration: 1.seconds,
                      )
                else
                  OnboardingButton(
                    titleString: currentIndex == 0 ? 'Get Started' : 'Next',
                    onTap: () {
                      pageController.jumpToPage(currentIndex + 1);
                    },
                  ).animate().fade(
                        curve: curve,
                        duration: 1.seconds,
                      ),
              ],
            ),
            SizedBox(height: gap * 3),
            DotsIndicator(
              dotsCount: OnboardingController().onboardingScreenViews.length,
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
          ],
        ),
      ),
    );
  }
}
