import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart' hide PageController;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:restart_app/restart_app.dart';

import '../../../../controllers/onboarding/onboarding_controller.dart';
import '../../../../controllers/page_controller.dart';
import '../../../../providers/page_providers.dart';
import '../../../../providers/settings_providers.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/helper_functions.dart';
import '../../../../widgets/custom_list_tile.dart';

class SignOutTile extends ConsumerWidget {
  const SignOutTile({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomListTile(
      responsiveWidth: true,
      contentPadding: EdgeInsets.symmetric(
        horizontal: gap * 2,
        vertical: gap,
      ),
      titleString: 'Sign out',
      leadingIconData: FontAwesomeIcons.rightFromBracket,
      textColor: context.theme.colorScheme.onPrimary,
      onTap: () {
        User user = FirebaseAuth.instance.currentUser!;
        log('$user', name: 'Signing out user');
        FirebaseAuth.instance.signOut().onError(
          (error, stackTrace) {
            log('$error', name: 'Error signing out user');
          },
        ).then(
          (_) {
            ref.read(currentPageProvider.notifier).state =
                PageController().writing;
            ref
                .read(
                    OnboardingController().onboardingCompletedProvider.notifier)
                .state = false;
            vibrate(ref.watch(navigationEnableHapticFeedbackProvider), () {
              Restart.restartApp();
            });
          },
        );
      },
    );
  }
}
