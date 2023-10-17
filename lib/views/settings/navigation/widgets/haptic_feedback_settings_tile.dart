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
      trailing: Switch(
        value: ref.watch(navigationEnableHapticFeedbackProvider),
        onChanged: (value) {
          vibrate(
            ref.watch(navigationEnableHapticFeedbackProvider),
            () async {
              ref.read(navigationEnableHapticFeedbackProvider.notifier).state =
                  value;
              await FirestorePreferencesController.instance.savePreference(
                PreferencesController.navigationEnableHapticFeedback.withValue(
                  ref.watch(navigationEnableHapticFeedbackProvider),
                ),
              );
              log(
                '${ref.watch(navigationEnableHapticFeedbackProvider)}',
                name: 'SettingsView:ShowAppBarTitle',
              );
            },
          );
        },
      ),
    );
  }
}
