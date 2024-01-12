import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../controllers/onboarding/onboarding_controller.dart';
import '../../../models/onboarding/onboarding_model.dart';
import '../../../utils/helper_functions.dart';
import '../widgets/onboarding_screen_view.dart';

class OnboardingPersonalizedInsightsView extends ConsumerWidget {
  const OnboardingPersonalizedInsightsView({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return OnboardingScreenView(
      onboardingScreenModel: OnboardingModel(
        hero: FaIcon(
          FontAwesomeIcons.chartSimple,
          color: context.theme.colorScheme.outline,
          size: 21.w,
        ),
        title: 'Personalized Insights',
        description:
            'Discover yourself through our advanced sentiment analysis. Healpen provides personalized insights into your emotional patterns, helping you understand your inner world better.',
        actionText: 'Continue',
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
