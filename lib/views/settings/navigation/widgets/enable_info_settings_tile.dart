import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../controllers/settings/firestore_preferences_controller.dart';
import '../../../../controllers/settings/preferences_controller.dart';
import '../../../../providers/settings_providers.dart';
import '../../../../utils/helper_functions.dart';
import '../../../../widgets/custom_list_tile.dart';

class EnableInfoSettingsTile extends ConsumerWidget {
  const EnableInfoSettingsTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomListTile(
      useSmallerNavigationSetting:
          !ref.watch(navigationSmallerNavigationElementsProvider),
      enableExplanationWrapper:
          !ref.watch(navigationSmallerNavigationElementsProvider),
      titleString: 'Enable informatory text',
      explanationString:
          'Enable the informatory text on below elements to learn more about them',
      trailing: Switch(
        value: ref.watch(navigationShowInfoProvider),
        onChanged: (value) {
          vibrate(
            ref.watch(navigationEnableHapticFeedbackProvider),
            () async {
              ref.read(navigationShowInfoProvider.notifier).state = value;
              await FirestorePreferencesController.instance.savePreference(
                PreferencesController.navigationShowInfo.withValue(
                  ref.watch(navigationShowInfoProvider),
                ),
              );
              log(
                '${ref.watch(navigationShowInfoProvider)}',
                name: 'SettingsView:EnableInfoSettingsTile',
              );
            },
          );
        },
      ),
    );
  }
}
