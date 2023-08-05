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
      titleString: 'Custom in-app navigation buttons',
      subtitle: const Text(
        'Enables custom in-app navigation buttons for easier navigation.',
      ),
      trailing: Switch(
        value: ref.watch(customNavigationButtonsProvider),
        onChanged: (value) async {
          ref.read(customNavigationButtonsProvider.notifier).state = value;
          writeCustomNavigationButtons(ref.watch(customNavigationButtonsProvider));
          log(
            '${ref.watch(customNavigationButtonsProvider)}',
            name: 'SettingsView:customNavigationButtons',
          );
        },
      ),
    );
  }
}