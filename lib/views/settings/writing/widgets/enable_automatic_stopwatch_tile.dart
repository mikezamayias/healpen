import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../controllers/settings/preferences_controller.dart';
import '../../../../providers/settings_providers.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/helper_functions.dart';
import '../../../../widgets/custom_list_tile.dart';

class EnableAutomaticStopwatchTile extends ConsumerWidget {
  const EnableAutomaticStopwatchTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomListTile(
      contentPadding: EdgeInsets.all(gap),
      enableSubtitleWrapper: true,
      titleString: 'Enable automatic stopwatch',
      enableExplanationWrapper: true,
      explanationString:
          'Pauses the stopwatch when you stop typing and resets it when you clear all text.',
      trailing: Switch(
        value: ref.watch(writingAutomaticStopwatchProvider),
        onChanged: (value) {
          vibrate(ref.watch(navigationEnableHapticFeedbackProvider), () async {
            ref.read(writingAutomaticStopwatchProvider.notifier).state = value;
            await PreferencesController.writingAutomaticStopwatch
                .write(ref.watch(writingAutomaticStopwatchProvider));
            log(
              '${ref.watch(writingAutomaticStopwatchProvider)}',
              name: 'SettingsWritingView:writingResetStopwatchOnEmpty',
            );
          });
        },
      ),
    );
  }
}
