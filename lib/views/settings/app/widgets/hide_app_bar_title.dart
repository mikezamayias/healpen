import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../controllers/settings/preferences_controller.dart';
import '../../../../providers/settings_providers.dart';
import '../../../../utils/constants.dart';
import '../../../../widgets/custom_list_tile.dart';

class HideAppBarTitle extends ConsumerWidget {
  const HideAppBarTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomListTile(
      contentPadding: EdgeInsets.all(gap),
      titleString: 'App bar title',
      subtitle: const Text(
        'Hides the title in the app bar, saving space for more information.',
      ),
      trailing: Switch(
        value: ref.watch(hideAppBarTitle),
        onChanged: (value) async {
          ref.read(hideAppBarTitle.notifier).state = value;
          PreferencesController().hideAppBarTitle.write(
            ref.watch(hideAppBarTitle),
          );
          log(
            '${ref.watch(hideAppBarTitle)}',
            name: 'SettingsView:HideAppBarTitle',
          );
        },
      ),
    );
  }
}
