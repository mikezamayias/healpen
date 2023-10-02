import 'dart:developer';

import 'package:flutter/material.dart' hide AppBar, ListTile, PageController;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../controllers/settings/preferences_controller.dart';
import '../../../../enums/app_theming.dart';
import '../../../../providers/settings_providers.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/helper_functions.dart';
import '../../../../widgets/custom_list_tile.dart';

class ThemeColorTile extends ConsumerWidget {
  const ThemeColorTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomListTile(
      contentPadding: EdgeInsets.all(gap),
      titleString: 'Color',
      explanationString: 'Changes the color of the app.',
      enableSubtitleWrapper: false,
      subtitle: SegmentedButton<ThemeColor>(
        showSelectedIcon: false,
        segments: <ButtonSegment<ThemeColor>>[
          for (ThemeColor themeColor in ThemeColor.values)
            ButtonSegment(
              value: themeColor,
              label: Text(themeColor.name),
            ),
        ],
        selected: {ref.watch(themeColorProvider)},
        onSelectionChanged: (Set<ThemeColor> newSelection) {
          vibrate(ref.watch(navigationEnableHapticFeedbackProvider), () async {
            ref.watch(themeColorProvider.notifier).state = newSelection.first;
            log(
              '${newSelection.first}',
              name: 'Settings:ThemeColorTile',
            );
            await PreferencesController.themeColor
                .write(ref.watch(themeColorProvider));
          });
        },
      ),
    );
  }
}
