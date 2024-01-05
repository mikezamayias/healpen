import 'package:flutter/material.dart' hide AppBar, ListTile, PageController;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../controllers/settings/firestore_preferences_controller.dart';
import '../../../../controllers/settings/preferences_controller.dart';
import '../../../../controllers/vibrate_controller.dart';
import '../../../../enums/app_theming.dart';
import '../../../../extensions/string_extensions.dart';
import '../../../../providers/settings_providers.dart';
import '../../../../utils/logger.dart';
import '../../../../widgets/custom_list_tile.dart';

class ThemeAppearanceTile extends ConsumerWidget {
  const ThemeAppearanceTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enableInformatoryText = ref.watch(navigationShowInfoProvider);
    return CustomListTile(
      useSmallerNavigationSetting:
          !ref.watch(navigationSmallerNavigationElementsProvider),
      enableExplanationWrapper:
          !ref.watch(navigationSmallerNavigationElementsProvider),
      titleString: 'Appearance',
      explanationString:
          enableInformatoryText ? 'Changes the appearance of the app.' : null,
      subtitle: SegmentedButton<ThemeAppearance>(
        showSelectedIcon: false,
        segments: <ButtonSegment<ThemeAppearance>>[
          for (ThemeAppearance appearance in ThemeAppearance.values)
            ButtonSegment(
              value: appearance,
              label: Text(appearance.name.toCapitalized()),
            ),
        ],
        selected: {ref.watch(themeAppearanceProvider)},
        onSelectionChanged: (Set<ThemeAppearance> newSelection) {
          VibrateController().run(() async {
            ref.watch(themeAppearanceProvider.notifier).state =
                newSelection.first;
            logger.i(
              '${newSelection.first}',
            );
            await FirestorePreferencesController.instance.savePreference(
                PreferencesController.themeAppearance
                    .withValue(ref.watch(themeAppearanceProvider)));
          });
        },
      ),
    );
  }
}
