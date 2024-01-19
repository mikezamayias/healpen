import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:url_launcher/url_launcher.dart';

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
        title: 'Permission to track app performance',
        description:
            'Healpen uses Crashlytics to track app performance and crashes, enabling us to improve the app and provide a better experience. You can learn more about Crashlytics in our Privacy Policy.',
        informativeActions: <OnboardingActionModel>[
          OnboardingActionModel(
            title: 'Privacy Policy',
            actionCallback: () => launchUrl(
              Uri.https(
                'iubenda.com',
                'privacy-policy/29795832',
              ),
              mode: LaunchMode.inAppWebView,
            ),
          ),
        ],
        actions: <OnboardingActionModel>[
          OnboardingActionModel(
            title: 'Allow',
          ),
          OnboardingActionModel(
            title: 'Don\'t Allow',
          ),
        ],
      ),
    );
  }
}
