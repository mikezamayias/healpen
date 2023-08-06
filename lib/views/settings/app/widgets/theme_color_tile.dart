import 'dart:developer';

import 'package:flutter/material.dart' hide AppBar, ListTile, PageController;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../controllers/settings/preferences_controller.dart';
import '../../../../enums/app_theming.dart';
import '../../../../providers/settings_providers.dart';
import '../../../../utils/constants.dart';
import '../../../../widgets/custom_list_tile.dart';

class ThemeColorTile extends ConsumerWidget {
  const ThemeColorTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomListTile(
      titleString: 'Color',
      contentPadding: EdgeInsets.all(gap),
      enableSubtitleWrapper: false,
      subtitle: SegmentedButton<ThemeColor>(
        showSelectedIcon: false,
        segments: <ButtonSegment<ThemeColor>>[
          for (ThemeColor appColor in ThemeColor.values)
            ButtonSegment(
              value: appColor,
              label: Text(appColor.name),
            ),
        ],
        selected: {ref.watch(themeColorProvider)},
        onSelectionChanged: (Set<ThemeColor> newSelection) {
          ref.watch(themeColorProvider.notifier).state = newSelection.first;
          log(
            '${newSelection.first}',
            name: 'Settings: ThemeAppearanceTile',
          );
          PreferencesController().themeColor.write(
                ref.watch(themeColorProvider)
              );
        },
      ),
    );
  }
}
