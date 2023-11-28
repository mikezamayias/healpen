import 'package:flutter/material.dart' hide PageController;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../controllers/onboarding/onboarding_controller.dart';
import '../../../controllers/page_controller.dart';
import '../../../utils/constants.dart';
import '../../../utils/helper_functions.dart';
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
    pushWithAnimation(
      context: context,
      widget: PageController().authView.widget,
      replacement: true,
    );
  }
}
