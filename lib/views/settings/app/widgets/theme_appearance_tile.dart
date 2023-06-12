import 'dart:developer';

import 'package:flutter/material.dart' hide AppBar, ListTile, PageController;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../controllers/app_theming_controller.dart';
import '../../../../enums/app_theming.dart';
import '../../../../extensions/string_extensions.dart';
import '../../../../widgets/custom_list_tile.dart';

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
        selected: {
          ref
              .watch(AppearanceController.instance.appearanceControllerProvider)
              .appearance
        },
        onSelectionChanged: (Set<Appearance> newSelection) {
          Appearance newAppearance = newSelection.first;
          ref
              .read(AppearanceController
                  .instance.appearanceControllerProvider.notifier)
              .updateAppearance(newAppearance);
          log(
            'Appearance changed to $newAppearance',
            name: 'Settings: ThemeAppearanceTile',
          );
        },
      ),
    );
  }
}
