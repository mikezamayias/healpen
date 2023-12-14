import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../controllers/settings/firestore_preferences_controller.dart';
import '../../../../controllers/settings/preferences_controller.dart';
import '../../../../providers/settings_providers.dart';
import '../../../../utils/helper_functions.dart';
import '../../../../utils/logger.dart';
import '../../../../widgets/custom_list_tile.dart';

class EnableSimpleUiTile extends ConsumerWidget {
  const EnableSimpleUiTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomListTile(
      useSmallerNavigationSetting:
          !ref.watch(navigationSmallerNavigationElementsProvider),
      enableExplanationWrapper:
          !ref.watch(navigationSmallerNavigationElementsProvider),
      titleString: 'Enable simple UI',
      explanationString: ref.watch(navigationShowInfoProvider)
          ? 'Enable a simpler UI for the app'
          : null,
      trailing: Switch(
        value: ref.watch(navigationSimpleUIProvider),
        onChanged: (bool value) {
          vibrate(
            ref.watch(navigationEnableHapticFeedbackProvider),
            () async {
              ref.read(navigationSimpleUIProvider.notifier).state = value;
              await FirestorePreferencesController.instance.savePreference(
                PreferencesController.navigationSimpleUI.withValue(
                  ref.watch(navigationSimpleUIProvider),
                ),
              );
              logger.i(
                '${ref.watch(navigationSimpleUIProvider)}',
              );
            },
          );
        },
      ),
    );
  }
}
