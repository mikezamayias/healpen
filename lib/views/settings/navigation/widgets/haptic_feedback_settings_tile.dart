import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../controllers/settings/firestore_preferences_controller.dart';
import '../../../../controllers/settings/preferences_controller.dart';
import '../../../../providers/settings_providers.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/helper_functions.dart';
import '../../../../widgets/custom_list_tile.dart';

class HapticFeedbackSettingsTile extends ConsumerWidget {
  const HapticFeedbackSettingsTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomListTile(
      contentPadding: EdgeInsets.all(gap),
      titleString: 'Enable haptic feedback',
      explanationString: 'Enables haptic feedback for buttons and other '
          'elements.',
      enableExplanationWrapper: true,
      trailing: StreamBuilder(
        stream: FirestorePreferencesController().getPreference(
            PreferencesController.navigationEnableHapticFeedback),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            log(
              'StreamBuilder Error: ${snapshot.error}',
              name: 'InfoButtonSettingsTile',
            );
          }
          if (snapshot.hasData) {
            PreferencesController.navigationEnableHapticFeedback.value =
                snapshot.data!.value;
          }
          return Switch(
            value: ref.watch(navigationEnableHapticFeedbackProvider),
            onChanged: (value) {
              vibrate(
                ref.watch(navigationEnableHapticFeedbackProvider),
                () async {
                  PreferencesController.navigationShowInfoButtons.value = value;
                  await FirestorePreferencesController.instance.savePreference(
                      PreferencesController.navigationEnableHapticFeedback
                          .withValue(PreferencesController
                              .navigationShowInfoButtons.value));
                  log(
                    '${PreferencesController.navigationShowInfoButtons.value}',
                    name: 'HapticFeedbackSettingsTile',
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
