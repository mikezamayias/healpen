import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../controllers/onboarding/onboarding_controller.dart';
import '../../../models/onboarding/onboarding_model.dart';
import '../../../utils/helper_functions.dart';
import '../widgets/onboarding_screen_view.dart';

class OnboardingBeginYourJourneyView extends ConsumerWidget {
  const OnboardingBeginYourJourneyView({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return OnboardingScreenView(
      onboardingScreenModel: OnboardingModel(
        hero: FaIcon(
          FontAwesomeIcons.chartLine,
          color: context.theme.colorScheme.outline,
          size: 21.w,
        ),
        title: 'Begin Your Journey',
        description:
            'You\'re all set! Reflect, write, and grow as you explore the landscape of your emotions and thoughts.',
        actions: <OnboardingActionModel>[
          OnboardingActionModel(
            title: 'Start Writing',
            actionCallback: () {
              ref
                  .read(
                      OnboardingController().currentPageIndexProvider.notifier)
                  .state = 0;
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
        ],
      ),
    );
  }
}