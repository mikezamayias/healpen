import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../controllers/onboarding/onboarding_controller.dart';
import '../../../models/onboarding/onboarding_model.dart';
import '../widgets/onboarding_screen_view.dart';

class OnboardingExpressiveWritingView extends ConsumerWidget {
  const OnboardingExpressiveWritingView({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return OnboardingScreenView(
      onboardingScreenModel: OnboardingModel(
        hero: FaIcon(
          FontAwesomeIcons.pencil,
          color: context.theme.colorScheme.outline,
          size: 21.w,
        ),
        title: 'Expressive Writing',
        description:
            'Pour your thoughts and feelings into words, and embark on a path to self-healing and emotional clarity.',
        actions: <OnboardingActionModel>[
          OnboardingActionModel(
            title: 'Continue',
            actionCallback: () {
              OnboardingController().nextPage(ref);
            },
          ),
        ],
      ),
    );
  }
}
