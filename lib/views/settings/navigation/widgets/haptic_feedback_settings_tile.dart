import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../controllers/settings/preferences_controller.dart';
import '../../../../providers/settings_providers.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/helper_functions.dart';
import '../../../../widgets/custom_list_tile.dart';

class ReduceHapticFeedbackSettingsTile extends ConsumerWidget {
  const ReduceHapticFeedbackSettingsTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomListTile(
      contentPadding: EdgeInsets.all(gap),
      titleString: 'Reduce haptic feedback',
      subtitle: const Text(
        'Reduces the amount of haptic feedback in the app.',
      ),
      trailing: Switch(
        value: ref.watch(navigationReduceHapticFeedbackProvider),
        onChanged: (value) {
          vibrate(ref.watch(navigationReduceHapticFeedbackProvider), () async {
            ref.read(navigationReduceHapticFeedbackProvider.notifier).state = value;
            await PreferencesController()
                .reduceHapticFeedback
                .write(ref.watch(navigationReduceHapticFeedbackProvider));
            log(
              '${ref.watch(navigationReduceHapticFeedbackProvider)}',
              name: 'SettingsView:ReduceHapticFeedbackSettingsTile',
            );
          });
        },
      ),
    );
  }
}
