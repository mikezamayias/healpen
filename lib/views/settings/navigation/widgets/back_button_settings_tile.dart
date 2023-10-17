import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../controllers/settings/firestore_preferences_controller.dart';
import '../../../../controllers/settings/preferences_controller.dart';
import '../../../../providers/settings_providers.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/helper_functions.dart';
import '../../../../widgets/custom_list_tile.dart';

class BackButtonSettingsTile extends ConsumerWidget {
  const BackButtonSettingsTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomListTile(
      contentPadding: EdgeInsets.all(gap),
      titleString: 'Enable back button in app bar',
      explanationString:
          'Shows a back button at the top of the screen, making it simpler to '
          'return to previous pages.',
      enableExplanationWrapper: true,
      trailing: Switch(
        value: ref.watch(navigationShowBackButtonProvider),
        onChanged: (value) {
          vibrate(
            ref.watch(navigationEnableHapticFeedbackProvider),
            () async {
              ref.read(navigationShowBackButtonProvider.notifier).state = value;
              await FirestorePreferencesController.instance.savePreference(
                PreferencesController.navigationShowBackButton.withValue(
                  ref.watch(navigationShowBackButtonProvider),
                ),
              );
              log(
                '${ref.watch(navigationShowBackButtonProvider)}',
                name: 'SettingsView:ShowAppBarTitle',
              );
            },
          );
        },
      ),
    );
  }
}
