import 'dart:developer';

import 'package:flutter/material.dart' hide AppBar, ListTile, PageController;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../enums/app_theming.dart';
import '../../../../extensions/string_extensions.dart';
import '../../../../providers/settings_providers.dart';
import '../../../../widgets/custom_list_tile.dart';

class ThemeAppearanceTile extends ConsumerWidget {
  const ThemeAppearanceTile({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomListTile(
      titleString: 'Appearance',
      subtitle: SegmentedButton<Appearance>(
        showSelectedIcon: false,
        segments: <ButtonSegment<Appearance>>[
          for (Appearance appAppearance in Appearance.values)
            ButtonSegment(
              value: appAppearance,
              label: Text(appAppearance.name.toCapitalized()),
            ),
        ],
        selected: {ref.watch(appearanceProvider)},
        onSelectionChanged: (Set<Appearance> newSelection) {
          ref.watch(appearanceProvider.notifier).state = newSelection.first;
          log(
            'Appearance changed to ${newSelection.first}',
            name: 'Settings: ThemeAppearanceTile',
          );
        },
      ),
    );
  }
}
