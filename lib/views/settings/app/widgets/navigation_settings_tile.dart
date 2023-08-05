import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../providers/settings_providers.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/helper_functions.dart';
import '../../../../widgets/custom_list_tile.dart';

class NavigationSettingsTile extends ConsumerWidget {
  const NavigationSettingsTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomListTile(
      contentPadding: EdgeInsets.all(gap),
      titleString: 'Back button in app bar',
      subtitle: const Text(
        'Turns on a back button at the top of the screen, making it simpler to return to previous pages.',
      ),
      trailing: Switch(
        value: ref.watch(customNavigationButtonsProvider),
        onChanged: (value) async {
          ref.read(customNavigationButtonsProvider.notifier).state = value;
          writeCustomNavigationButtons(
              ref.watch(customNavigationButtonsProvider));
          log(
            '${ref.watch(customNavigationButtonsProvider)}',
            name: 'SettingsView:customNavigationButtons',
          );
        },
      ),
    );
  }
}
