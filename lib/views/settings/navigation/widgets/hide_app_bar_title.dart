import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../controllers/settings/preferences_controller.dart';
import '../../../../providers/settings_providers.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/helper_functions.dart';
import '../../../../widgets/custom_list_tile.dart';

class ShowAppBarTitle extends ConsumerWidget {
  const ShowAppBarTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomListTile(
      contentPadding: EdgeInsets.all(gap),
      titleString: 'Show app bar title on main pages',
      subtitle: const Text(
        'Shows the title in the app bar, making it simpler to know which of '
        'the main pages you are on. Disabling this will save space for more '
        'information.',
      ),
      trailing: Switch(
        value: ref.watch(navigationShowAppBarTitle),
        onChanged: (value) {
          vibrate(ref.watch(navigationReduceHapticFeedbackProvider), () async {
            ref.read(navigationShowAppBarTitle.notifier).state = value;
            await PreferencesController()
                .showAppBarTitle
                .write(ref.watch(navigationShowAppBarTitle));
            log(
              '${ref.watch(navigationShowAppBarTitle)}',
              name: 'SettingsView:ShowAppBarTitle',
            );
          });
        },
      ),
    );
  }
}
