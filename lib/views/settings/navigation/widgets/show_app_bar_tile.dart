import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../controllers/settings/firestore_preferences_controller.dart';
import '../../../../controllers/settings/preferences_controller.dart';
import '../../../../providers/settings_providers.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/helper_functions.dart';
import '../../../../widgets/custom_list_tile.dart';

class ShowAppBarTile extends ConsumerWidget {
  const ShowAppBarTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomListTile(
      contentPadding: EdgeInsets.all(gap),
      titleString: 'Enable app bar on main pages',
      explanationString:
          'Displays the app bar of the current page, making it easier to '
          'determine which main page you are currently on. If disabled, this '
          'will create more space for additional information.',
      enableExplanationWrapper: true,
      trailing: Switch(
        value: ref.watch(navigationShowAppBarProvider),
        onChanged: (value) {
          vibrate(
            ref.watch(navigationEnableHapticFeedbackProvider),
            () async {
              ref.read(navigationShowAppBarProvider.notifier).state = value;
              await FirestorePreferencesController.instance.savePreference(
                PreferencesController.navigationShowAppBar.withValue(
                  ref.watch(navigationShowAppBarProvider),
                ),
              );
              log(
                '${ref.watch(navigationShowAppBarProvider)}',
                name: 'SettingsView:ShowAppBarTitle',
              );
            },
          );
        },
      ),
    );
  }
}
