import 'dart:developer';

import 'package:flutter/material.dart' hide AppBar, ListTile, PageController;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';

import '../../../../controllers/settings/firestore_preferences_controller.dart';
import '../../../../controllers/settings/preferences_controller.dart';
import '../../../../enums/app_theming.dart';
import '../../../../extensions/string_extensions.dart';
import '../../../../providers/settings_providers.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/helper_functions.dart';
import '../../../../widgets/custom_list_tile.dart';

class ThemeAppearanceTile extends ConsumerWidget {
  const ThemeAppearanceTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomListTile(
      contentPadding: EdgeInsets.all(gap),
      titleString: 'Appearance',
      explanationString: 'Changes the appearance of the app.',
      enableExplanationWrapper: true,
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
          vibrate(ref.watch(navigationEnableHapticFeedbackProvider), () {
            ref.watch(themeAppearanceProvider.notifier).state =
                newSelection.first;
            log(
              '${newSelection.first}',
              name: 'Settings: ThemeAppearanceTile',
            );
            FirestorePreferencesController.instance
                .savePreference(PreferencesController.themeAppearance
                    .withValue(ref.watch(themeAppearanceProvider)))
                .whenComplete(() {
              getSystemUIOverlayStyle(
                context.theme,
                ref.watch(themeAppearanceProvider),
              );
            });
          });
        },
      ),
    );
  }
}
