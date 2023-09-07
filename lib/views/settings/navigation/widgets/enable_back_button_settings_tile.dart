import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../controllers/settings/preferences_controller.dart';
import '../../../../providers/settings_providers.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/helper_functions.dart';
import '../../../../widgets/custom_list_tile.dart';

class ShowBackButtonSettingsTile extends ConsumerWidget {
  const ShowBackButtonSettingsTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomListTile(
      contentPadding: EdgeInsets.all(gap),
      titleString: 'Show back button in app bar',
      subtitle: const Text(
        'Shows a back button at the top of the screen, making it simpler to '
        'return to previous pages.',
      ),
      trailing: Switch(
        value: ref.watch(navigationShowBackButtonProvider),
        onChanged: (value) {
          vibrate(ref.watch(navigationReduceHapticFeedbackProvider), () async {
            ref.read(navigationShowBackButtonProvider.notifier).state = value;
            await PreferencesController()
                .showBackButton
                .write(ref.watch(navigationShowBackButtonProvider));
            log(
            '${ref.watch(navigationShowBackButtonProvider)}',
            name: 'SettingsView:ShowBackButtonSettingsTile',
          );
          });
        },
      ),
    );
  }
}
