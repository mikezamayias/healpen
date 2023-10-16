import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iterum/flutter_iterum.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../controllers/onboarding/onboarding_controller.dart';
import '../../../../controllers/page_controller.dart' as page_controller;
import '../../../../controllers/settings/preferences_controller.dart';
import '../../../../models/settings/preference_model.dart';
import '../../../../providers/page_providers.dart';
import '../../../../utils/constants.dart';
import '../../../../widgets/custom_list_tile.dart';

class SignOutTile extends ConsumerStatefulWidget {
  const SignOutTile({
    super.key,
  });

  @override
  ConsumerState<SignOutTile> createState() => _SignOutTileState();
}

class _SignOutTileState extends ConsumerState<SignOutTile> {
  @override
  Widget build(BuildContext context) {
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
        log('CustomListTile: onTap', name: 'SignOutTile');
        log('${FirebaseAuth.instance.currentUser}', name: 'SignOutTile');
        FirebaseUIAuth.signOut().whenComplete(() {
          log('signOut().complete', name: 'SignOutTile');
          log('${FirebaseAuth.instance.currentUser}', name: 'SignOutTile');
          Iterum.revive(context);
          resetState();
          context.navigator.popAndPushNamed('/onboarding');
        });
      },
    );
  }

  void resetState() {
    ref.read(OnboardingController().pageControllerProvider).dispose();
    ref.read(OnboardingController().pageControllerProvider.notifier).state =
        PageController();
    PageController();
    ref.read(currentPageProvider.notifier).state =
        page_controller.PageController().writing;
    ref.read(OnboardingController.onboardingCompletedProvider.notifier).state =
        false;
    for (({
      PreferenceModel preferenceModel,
      StateProvider provider
    }) preferenceTuple in PreferencesController().preferences) {
      var key = preferenceTuple.preferenceModel.key;
      var value = preferenceTuple.preferenceModel.value;
      ref.read(preferenceTuple.provider.notifier).state = value;
      preferenceTuple.preferenceModel.withValue(value);
      log(
        'Updated $key with value: $value',
        name: 'SignOutTile:resetPreferences',
      );
    }
  }
}
