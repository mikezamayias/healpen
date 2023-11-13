import 'package:flutter/material.dart' hide PageController;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';

import '../../../controllers/onboarding/onboarding_controller.dart';
import '../../../controllers/page_controller.dart';
import '../../../utils/constants.dart';
import 'onboarding_button.dart';

class OnboardingNavigationBar extends ConsumerWidget {
  const OnboardingNavigationBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.only(top: gap * 2, bottom: gap * 6),
      child: OnboardingButton(
        titleString: 'Start Writing Now',
        onTap: () => goToAuth(context, ref),
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
}
