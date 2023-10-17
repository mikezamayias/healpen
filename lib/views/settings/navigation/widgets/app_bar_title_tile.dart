import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../controllers/settings/firestore_preferences_controller.dart';
import '../../../../controllers/settings/preferences_controller.dart';
import '../../../../providers/settings_providers.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/helper_functions.dart';
import '../../../../widgets/custom_list_tile.dart';

class AppBarTitleTitle extends ConsumerWidget {
  const AppBarTitleTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomListTile(
      contentPadding: EdgeInsets.all(gap),
      titleString: 'Enable app bar title on main pages',
      explanationString:
          'Shows the title in the app bar, making it simpler to know which of '
          'the main pages you are on. Disabling this will save space for more '
          'information.',
      enableExplanationWrapper: true,
      trailing: Switch(
        value: ref.watch(navigationShowAppBarTitleProvider),
        onChanged: (value) {
          vibrate(ref.watch(navigationEnableHapticFeedbackProvider), () async {
            ref.read(navigationShowAppBarTitleProvider.notifier).state = value;
            await FirestorePreferencesController.instance.savePreference(
                PreferencesController.navigationShowAppBarTitle.withValue(
                  ref.watch(navigationShowAppBarTitleProvider),
                ),
              );
              log(
                '${ref.watch(navigationShowAppBarTitleProvider)}',
                name: 'SettingsView:ShowAppBarTitle',
              );
            },
          );
        },
      ),
    );
  }
}
