import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../controllers/onboarding/onboarding_controller.dart';
import '../../../models/onboarding/onboarding_model.dart';
import '../../../utils/helper_functions.dart';
import '../widgets/onboarding_screen_view.dart';

class OnboardingWelcomeView extends ConsumerWidget {
  const OnboardingWelcomeView({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return OnboardingScreenView(
      onboardingScreenModel: OnboardingModel(
        hero: Image.asset(
          'assets/icon/brain-2x.png',
          fit: BoxFit.contain,
          height: 24.w,
          width: 24.w,
        ),
        title: 'Welcome',
        description:
            'Healpen is your personal space for expressive writing and self-discovery. Begin your journey towards better mental health and deeper self-awareness.',
        actionText: 'Next',
        actionCallback: () {
          ref
              .read(OnboardingController().currentPageIndexProvider.notifier)
              .state++;
          pushWithAnimation(
            context: context,
            widget: OnboardingController.views.elementAt(
              ref.read(OnboardingController().currentPageIndexProvider),
            ),
            replacement: true,
            dataCallback: null,
          );
        },
      ),
    );
  }
}
