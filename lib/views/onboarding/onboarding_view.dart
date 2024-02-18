import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/onboarding/onboarding_controller.dart';
import '../../utils/constants.dart';
import '../blueprint/blueprint_view.dart';

class OnboardingView extends ConsumerStatefulWidget {
  const OnboardingView({super.key});

  @override
  ConsumerState<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends ConsumerState<OnboardingView> {
  // late PageController pageController;
  double viewPortFraction = 1;
  double pageOffset = 0;

  @override
  void initState() {
    // pageController = PageController(
    //   viewportFraction: viewPortFraction,
    // )..addListener(() {
    //     setState(() {
    //       pageOffset = pageController.page!;
    //     });
    //   });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlueprintView(
      padBodyHorizontally: false,
      body: Padding(
        padding: EdgeInsets.all(radius),
        child: PageView.builder(
          clipBehavior: Clip.none,
          controller: ref.watch(OnboardingController().pageControllerProvider),
          physics: const NeverScrollableScrollPhysics(),
          itemCount: OnboardingController.views.length,
          // onPageChanged: (int index) {
          //   VibrateController().run(() {
          //     animateToPage(
          //       ref.read(OnboardingController().pageControllerProvider),
          //       index,
          //     );
          //     ref
          //         .read(
          //             OnboardingController().currentPageIndexProvider.notifier)
          //         .state = index;
          //   });
          // },
          itemBuilder: (context, index) => OnboardingController.views[index],
          // itemBuilder: (context, index) {
          //   double scale = max(viewPortFraction,
          //       (1 - (pageOffset - index).abs()) + viewPortFraction);
          //   double angle = (pageOffset - index).abs();
          //   if (angle > 0.5) {
          //     angle = 1 - angle;
          //   }
          //   return AnimatedContainer(
          //     duration: standardDuration,
          //     curve: standardCurve,
          //     margin: EdgeInsets.symmetric(
          //       vertical: gap * scale,
          //       horizontal: gap,
          //     ),
          //     padding: EdgeInsets.symmetric(
          //       vertical: 100 - scale * 50,
          //     ),
          //     transform: Matrix4.identity()
          //       ..setEntry(3, 2, 0.001)
          //       ..rotateY(angle),
          //     alignment: Alignment.center,
          //     child: OnboardingController().currentOnboardingScreenView(index),
          //   );
          // },
        ),
      ),
    );
    // return const OnboardingWelcomeView();
  }
}
