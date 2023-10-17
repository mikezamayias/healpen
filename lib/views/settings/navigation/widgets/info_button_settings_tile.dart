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
      trailing: StreamBuilder(
        stream: FirestorePreferencesController()
            .getPreference(PreferencesController.navigationShowInfoButtons),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            log(
              '${snapshot.error}',
              name: 'InfoButtonSettingsTile:StreamBuilder - Error',
            );
          }
          if (snapshot.hasData) {
            PreferencesController.navigationShowInfoButtons.value =
                snapshot.data!.value;
          }
          return Switch(
            value: ref.watch(navigationShowInfoButtonsProvider),
            onChanged: (value) {
              vibrate(
                ref.watch(navigationEnableHapticFeedbackProvider),
                () async {
                  PreferencesController.navigationShowInfoButtons.value = value;
                  ref
                      .read(navigationShowInfoButtonsProvider.notifier)
                      .state = value;
                  await FirestorePreferencesController.instance.savePreference(
                    PreferencesController.navigationShowInfoButtons,
                  );
                  log(
                    '${PreferencesController.navigationShowInfoButtons.value}',
                    name: 'InfoButtonSettingsTile:StreamBuilder - onChanged',
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
