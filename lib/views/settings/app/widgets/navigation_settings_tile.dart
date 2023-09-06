import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../controllers/settings/preferences_controller.dart';
import '../../../../providers/settings_providers.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/helper_functions.dart';
import '../../../../widgets/custom_list_tile.dart';

class EnableBackButtonSettingsTile extends ConsumerWidget {
  const EnableBackButtonSettingsTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomListTile(
      contentPadding: EdgeInsets.all(gap),
      titleString: 'Back button in app bar',
      subtitle: const Text(
        'Turns on a back button at the top of the screen, making it simpler to return to previous pages.',
      ),
      trailing: Switch(
        value: ref.watch(enableBackButtonProvider),
        onChanged: (value) {
          vibrate(ref.watch(reduceHapticFeedbackProvider), () async {
            ref.read(enableBackButtonProvider.notifier).state = value;
            await PreferencesController()
                .enableBackButton
                .write(ref.watch(enableBackButtonProvider));
            log(
            '${ref.watch(enableBackButtonProvider)}',
            name: 'SettingsView:EnableBackButtonSettingsTile',
          );
          });
        },
      ),
    );
  }
}
