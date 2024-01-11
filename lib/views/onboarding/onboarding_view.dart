import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/onboarding/onboarding_controller.dart';
import '../../controllers/page_controller.dart' as page_controller;
import '../../utils/helper_functions.dart';
import 'views/welcome_view.dart';

class OnboardingView extends ConsumerStatefulWidget {
  const OnboardingView({super.key});

  @override
  ConsumerState<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends ConsumerState<OnboardingView> {
  late PageController pageController;
  double viewPortFraction = 1;
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
    //   return BlueprintView(
    //     body: PageView.builder(
    //       clipBehavior: Clip.none,
    //       controller: pageController,
    //       physics: const NeverScrollableScrollPhysics(),
    //       itemCount: OnboardingController().onboardingScreenViews.length,
    //       onPageChanged: (int index) {
    //         VibrateController().run(() {
    //           animateToPage(pageController, index);
    //           ref
    //               .read(OnboardingController().currentPageIndexProvider.notifier)
    //               .state = index;
    //         });
    //       },
    //       itemBuilder: (context, index) {
    //         double scale = max(viewPortFraction,
    //             (1 - (pageOffset - index).abs()) + viewPortFraction);
    //         double angle = (pageOffset - index).abs();
    //         if (angle > 0.5) {
    //           angle = 1 - angle;
    //         }
    //         return AnimatedContainer(
    //           duration: standardDuration,
    //           curve: standardCurve,
    //           margin: EdgeInsets.symmetric(
    //             vertical: gap * scale,
    //             horizontal: gap,
    //           ),
    //           padding: EdgeInsets.symmetric(
    //             vertical: 100 - scale * 50,
    //           ),
    //           transform: Matrix4.identity()
    //             ..setEntry(3, 2, 0.001)
    //             ..rotateY(angle),
    //           alignment: Alignment.center,
    //           child: OnboardingController().currentOnboardingScreenView(index),
    //         );
    //       },
    //     ),
    //   );
    return const OnboardingWelcomeView();
  }

  void goToAuth(BuildContext context, WidgetRef ref) async {
    pushWithAnimation(
      context: context,
      widget: page_controller.PageController().authView.widget,
      replacement: true,
      dataCallback: () {
        ref
            .read(OnboardingController.onboardingCompletedProvider.notifier)
            .state = true;
      },
    );
  }
}
