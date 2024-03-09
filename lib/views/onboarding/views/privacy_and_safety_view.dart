import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../controllers/onboarding/onboarding_controller.dart';
import '../../../models/onboarding/onboarding_model.dart';
import '../widgets/onboarding_screen_view.dart';

class OnboardingPivacyAndSafetyView extends ConsumerWidget {
  const OnboardingPivacyAndSafetyView({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return OnboardingScreenView(
      onboardingScreenModel: OnboardingModel(
        hero: FaIcon(
          FontAwesomeIcons.shieldHalved,
          color: context.theme.colorScheme.outline,
          size: 21.w,
        ),
        title: 'Privacy and Safety',
        description:
            'Your entries are securely stored, and our sentiment analysis is done with utmost confidentiality.',
        actions: <OnboardingActionModel>[
          OnboardingActionModel(
            title: 'Acknowledge',
            actionCallback: () {
              // ref.read(OnboardingController().pageControllerProvider);
              OnboardingController().nextPage(ref);
            },
          ),
        ],
      ),
    );
  }
}
