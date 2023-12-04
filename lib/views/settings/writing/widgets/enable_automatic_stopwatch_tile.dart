import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../controllers/settings/firestore_preferences_controller.dart';
import '../../../../controllers/settings/preferences_controller.dart';
import '../../../../providers/settings_providers.dart';
import '../../../../utils/helper_functions.dart';
import '../../../../utils/logger.dart';
import '../../../../widgets/custom_list_tile.dart';

class EnableAutomaticStopwatchTile extends ConsumerWidget {
  const EnableAutomaticStopwatchTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enableInformatoryText = ref.watch(navigationShowInfoProvider);
    return CustomListTile(
      useSmallerNavigationSetting:
          !ref.watch(navigationSmallerNavigationElementsProvider),
      enableExplanationWrapper:
          !ref.watch(navigationSmallerNavigationElementsProvider),
      enableSubtitleWrapper: true,
      titleString: 'Enable automatic stopwatch',
      explanationString: enableInformatoryText
          ? 'Pauses the stopwatch when you stop typing and resets it when you clear all text.'
          : null,
      trailing: Switch(
        value: ref.watch(writingAutomaticStopwatchProvider),
        onChanged: (value) {
          vibrate(
            ref.watch(navigationEnableHapticFeedbackProvider),
            () async {
              ref.read(writingAutomaticStopwatchProvider.notifier).state =
                  value;
              await FirestorePreferencesController.instance.savePreference(
                PreferencesController.writingAutomaticStopwatch.withValue(
                  ref.watch(writingAutomaticStopwatchProvider),
                ),
              );
              logger.i(
                '${ref.watch(writingAutomaticStopwatchProvider)}',
              );
            },
          );
        },
      ),
    );
  }
}
