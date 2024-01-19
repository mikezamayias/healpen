import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../models/onboarding/onboarding_model.dart';
import '../widgets/onboarding_screen_view.dart';

class OnboardingCrashlyticsView extends ConsumerWidget {
  const OnboardingCrashlyticsView({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return OnboardingScreenView(
      onboardingScreenModel: OnboardingModel(
        hero: FaIcon(
          FontAwesomeIcons.bug,
          color: context.theme.colorScheme.outline,
          size: 21.w,
        ),
        title: 'Crashlytics',
        description:
            'Crashlytics is a tool that helps us track and fix crashes in our app. It is a part of Firebase, and is owned by Google.',
        actions: <OnboardingActionModel>[
          OnboardingActionModel(
            title: 'Acknowledge',
          ),
          OnboardingActionModel(
            title: 'Learn More',
          ),
        ],
      ),
    );
  }
}
