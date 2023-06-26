import 'dart:developer';

import 'package:flutter/material.dart' hide AppBar, ListTile, PageController;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../enums/app_theming.dart';
import '../../../../extensions/string_extensions.dart';
import '../../../../providers/settings_providers.dart';
import '../../../../utils/helper_functions.dart';
import '../../../../widgets/custom_list_tile/custom_list_tile.dart';

class ThemeAppearanceTile extends ConsumerWidget {
  const ThemeAppearanceTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomListTile(
      titleString: 'Appearance',
      subtitle: SegmentedButton<Appearance>(
        showSelectedIcon: false,
        segments: <ButtonSegment<Appearance>>[
          for (Appearance appearance in Appearance.values)
            ButtonSegment(
              value: appearance,
              label: Text(appearance.name.toCapitalized()),
            ),
        ],
        selected: {ref.watch(appearanceProvider)},
        onSelectionChanged: (Set<Appearance> newSelection) {
          ref.watch(appearanceProvider.notifier).state = newSelection.first;
          log(
            'Theme appearance changed to ${newSelection.first}',
            name: 'Settings: ThemeAppearanceTile',
          );
          writeAppearance(ref.watch(appearanceProvider));
        },
      ),
    );
  }
}
