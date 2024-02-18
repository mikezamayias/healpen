import 'package:flutter/material.dart' hide PageController;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../controllers/onboarding/onboarding_controller.dart';
import '../../../models/onboarding/onboarding_model.dart';
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
            'Healpen is your personal space for expressive writing and self-exploration. It allows you to delve deeper into self-awareness and understanding.',
        actions: <OnboardingActionModel>[
          OnboardingActionModel(
            title: 'Next',
            actionCallback: () {
              OnboardingController().nextPage(ref);
            },
          ),
        ],
      ),
    );
  }
}
