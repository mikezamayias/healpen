import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../controllers/settings/firestore_preferences_controller.dart';
import '../../../../controllers/settings/preferences_controller.dart';
import '../../../../providers/settings_providers.dart';
import '../../../../utils/helper_functions.dart';
import '../../../../utils/logger.dart';
import '../../../../widgets/custom_list_tile.dart';

class HapticFeedbackSettingsTile extends ConsumerWidget {
  const HapticFeedbackSettingsTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enableInformatoryText = ref.watch(navigationShowInfoProvider);
    return CustomListTile(
      useSmallerNavigationSetting:
          !ref.watch(navigationSmallerNavigationElementsProvider),
      enableExplanationWrapper:
          !ref.watch(navigationSmallerNavigationElementsProvider),
      titleString: 'Enable haptic feedback',
      explanationString: enableInformatoryText
          ? 'Enables haptic feedback for buttons and other '
              'elements.'
          : null,
      trailing: Switch(
        value: ref.watch(navigationEnableHapticFeedbackProvider),
        onChanged: (value) {
          vibrate(
            ref.watch(navigationEnableHapticFeedbackProvider),
            () async {
              ref.read(navigationEnableHapticFeedbackProvider.notifier).state =
                  value;
              await FirestorePreferencesController.instance.savePreference(
                PreferencesController.navigationEnableHapticFeedback.withValue(
                  ref.watch(navigationEnableHapticFeedbackProvider),
                ),
              );
              logger.i(
                '${ref.watch(navigationEnableHapticFeedbackProvider)}',
              );
            },
          );
        },
      ),
    );
  }
}
