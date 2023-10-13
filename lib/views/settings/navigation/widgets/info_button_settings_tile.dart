import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../controllers/settings/firestore_preferences_controller.dart';
import '../../../../controllers/settings/preferences_controller.dart';
import '../../../../providers/settings_providers.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/helper_functions.dart';
import '../../../../widgets/custom_list_tile.dart';

class InfoButtonSettingsTile extends ConsumerWidget {
  const InfoButtonSettingsTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomListTile(
      contentPadding: EdgeInsets.all(gap),
      titleString: 'Enable info buttons',
      explanationString:
          'Shows an info button on the top left corner of many elements',
      enableExplanationWrapper: true,
      trailing: Switch(
        value: ref.watch(navigationShowInfoButtonsProvider),
        onChanged: (value) {
          vibrate(ref.watch(navigationShowInfoButtonsProvider), () async {
            ref.read(navigationShowInfoButtonsProvider.notifier).state = value;
            await FirestorePreferencesController.instance.savePreference(
                PreferencesController.navigationShowInfoButtons
                    .withValue(ref.watch(navigationShowInfoButtonsProvider)));
            log(
              '${ref.watch(navigationShowInfoButtonsProvider)}',
              name: 'InfoButtonSettingsTile',
            );
          });
        },
      ),
    );
  }
}
