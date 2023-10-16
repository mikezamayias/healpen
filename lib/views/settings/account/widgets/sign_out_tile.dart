import 'dart:developer';

import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart' hide PageController;
import 'package:flutter_iterum/flutter_iterum.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../controllers/onboarding/onboarding_controller.dart';
import '../../../../controllers/page_controller.dart';
import '../../../../providers/page_providers.dart';
import '../../../../utils/constants.dart';
import '../../../../widgets/custom_list_tile.dart';

class SignOutTile extends ConsumerWidget {
  const SignOutTile({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // return const SignOutButton(
    //   variant: ButtonVariant.outlined,
    // );
    return CustomListTile(
      responsiveWidth: true,
      contentPadding: EdgeInsets.symmetric(
        horizontal: gap * 2,
        vertical: gap,
      ),
      titleString: 'Sign out',
      leadingIconData: FontAwesomeIcons.rightFromBracket,
      textColor: context.theme.colorScheme.onPrimary,
      onTap: () async {
        log('CustomListTile: onTap', name: 'SignOutTile');
        SignedOutAction((context) {
          log('Action: SignedOutAction', name: 'SignOutTile');
          log('FirebaseUIAuth.signOut().then()', name: 'SignOutTile');
          ref.read(currentPageProvider.notifier).state =
              PageController().writing;
          ref
              .read(OnboardingController.onboardingCompletedProvider.notifier)
              .state = false;
          Iterum.revive(context);
        });
        await FirebaseUIAuth.signOut();
      },
    );
  }
}
