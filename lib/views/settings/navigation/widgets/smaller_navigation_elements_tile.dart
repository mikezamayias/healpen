import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../controllers/settings/firestore_preferences_controller.dart';
import '../../../../controllers/settings/preferences_controller.dart';
import '../../../../providers/settings_providers.dart';
import '../../../../utils/helper_functions.dart';
import '../../../../utils/logger.dart';
import '../../../../widgets/custom_list_tile.dart';

class SmallerNavigationElementsTile extends ConsumerWidget {
  const SmallerNavigationElementsTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enableInformatoryText = ref.watch(navigationShowInfoProvider);
    return CustomListTile(
      useSmallerNavigationSetting:
          !ref.watch(navigationSmallerNavigationElementsProvider),
      enableExplanationWrapper:
          !ref.watch(navigationSmallerNavigationElementsProvider),
      titleString: 'Enable smaller buttons and menus',
      explanationString: enableInformatoryText
          ? 'Shows smaller buttons and menus. '
              'This is useful for devices with smaller screens.'
          : null,
      trailing: Switch(
        value: ref.watch(navigationSmallerNavigationElementsProvider),
        onChanged: ref.watch(navigationSimpleUIProvider)
            ? null
            : (value) {
                vibrate(
                  ref.watch(navigationEnableHapticFeedbackProvider),
                  () async {
                    ref
                        .read(navigationSmallerNavigationElementsProvider
                            .notifier)
                        .state = value;
                    await FirestorePreferencesController.instance
                        .savePreference(
                      PreferencesController.navigationSmallerNavigationElements
                          .withValue(
                        ref.watch(navigationSmallerNavigationElementsProvider),
                      ),
                    );
                    logger.i(
                      '${ref.watch(navigationSmallerNavigationElementsProvider)}',
                    );
                  },
                );
              },
      ),
    );
  }
}
