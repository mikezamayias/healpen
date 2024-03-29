import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iterum/flutter_iterum.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../controllers/healpen/healpen_controller.dart';
import '../../../../controllers/insights_controller.dart';
import '../../../../controllers/settings/preferences_controller.dart';
import '../../../../models/insight_model.dart';
import '../../../../models/settings/preference_model.dart';
import '../../../../providers/settings_providers.dart';
import '../../../../route_controller.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/logger.dart';
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
      useSmallerNavigationSetting:
          !ref.watch(navigationSmallerNavigationElementsProvider),
      enableExplanationWrapper:
          !ref.watch(navigationSmallerNavigationElementsProvider),
      responsiveWidth: true,
      contentPadding: EdgeInsets.symmetric(
        horizontal: gap * 2,
        vertical: gap,
      ),
      titleString: 'Sign out',
      leadingIconData: FontAwesomeIcons.rightFromBracket,
      textColor: context.theme.colorScheme.onPrimary,
      onTap: () {
        logger.i(
          'CustomListTile: onTap',
        );
        logger.i(
          '${FirebaseAuth.instance.currentUser}',
        );
        FirebaseUIAuth.signOut().whenComplete(
          () {
            logger.i(
              'signOut().complete',
            );
            logger.i(
              '${FirebaseAuth.instance.currentUser}',
            );
            resetState();
            Iterum.revive(context);
            context.navigator.pushNamedAndRemoveUntil(
              RouterController.authWrapperRoute.route,
              (route) => false,
            );
          },
        );
      },
    );
  }

  void resetState() {
    ref.read(HealpenController().currentPageIndexProvider.notifier).state = 0;
    for (({
      PreferenceModel preferenceModel,
      StateProvider provider,
      bool log,
    }) preferenceTuple in PreferencesController().preferences) {
      var key = preferenceTuple.preferenceModel.key;
      var value = preferenceTuple.preferenceModel.value;
      if (key != PreferencesController.insightOrder.key) {
        ref.read(preferenceTuple.provider.notifier).state = value;
        preferenceTuple.preferenceModel.withValue(value);
      } else {
        final List<String> list = List<String>.from(
          InsightsController()
              .insightModelList
              .map((InsightModel element) => element.title),
        );
        preferenceTuple.preferenceModel.withValue(list);
      }
      logger.i(
        'Updated $key with value: $value',
      );
    }
  }
}
