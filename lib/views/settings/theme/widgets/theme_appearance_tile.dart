import 'dart:developer';

import 'package:flutter/material.dart' hide AppBar, ListTile, PageController;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../controllers/settings/firestore_preferences_controller.dart';
import '../../../../controllers/settings/preferences_controller.dart';
import '../../../../enums/app_theming.dart';
import '../../../../extensions/string_extensions.dart';
import '../../../../providers/settings_providers.dart';
import '../../../../utils/helper_functions.dart';
import '../../../../widgets/custom_list_tile.dart';

class ThemeAppearanceTile extends ConsumerWidget {
  const ThemeAppearanceTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomListTile(
      useSmallerNavigationSetting:
          !ref.watch(navigationSmallerNavigationElementsProvider),
      enableExplanationWrapper:
          !ref.watch(navigationSmallerNavigationElementsProvider),
      titleString: 'Appearance',
      explanationString: 'Changes the appearance of the app.',
      enableSubtitleWrapper: false,
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
          vibrate(ref.watch(navigationEnableHapticFeedbackProvider), () async {
            ref.watch(themeAppearanceProvider.notifier).state =
                newSelection.first;
            log(
              '${newSelection.first}',
              name: 'Settings: ThemeAppearanceTile',
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
