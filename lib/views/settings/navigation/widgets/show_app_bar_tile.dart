import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../controllers/settings/firestore_preferences_controller.dart';
import '../../../../controllers/settings/preferences_controller.dart';
import '../../../../providers/settings_providers.dart';
import '../../../../utils/helper_functions.dart';
import '../../../../utils/logger.dart';
import '../../../../widgets/custom_list_tile.dart';

class ShowAppBarTile extends ConsumerWidget {
  const ShowAppBarTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enableInformatoryText = ref.watch(navigationShowInfoProvider);
    return CustomListTile(
      useSmallerNavigationSetting:
          !ref.watch(navigationSmallerNavigationElementsProvider),
      enableExplanationWrapper:
          !ref.watch(navigationSmallerNavigationElementsProvider),
      titleString: 'Enable app bar on main pages',
      explanationString: enableInformatoryText
          ? 'Displays the app bar of the current page, making it easier to '
              'determine which main page you are currently on. If disabled, this '
              'will create more space for additional information.'
          : null,
      trailing: Switch(
        value: ref.watch(navigationShowAppBarProvider),
        onChanged: ref.watch(navigationSimpleUIProvider)
            ? null
            : (value) {
                vibrate(
                  ref.watch(navigationEnableHapticFeedbackProvider),
                  () async {
                    ref.read(navigationShowAppBarProvider.notifier).state =
                        value;
                    await FirestorePreferencesController.instance
                        .savePreference(
                      PreferencesController.navigationShowAppBar.withValue(
                        ref.watch(navigationShowAppBarProvider),
                      ),
                    );
                    logger.i(
                      '${ref.watch(navigationShowAppBarProvider)}',
                    );
                  },
                );
              },
      ),
    );
  }
}
