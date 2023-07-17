import 'dart:developer';

import 'package:flutter/material.dart' hide AppBar, ListTile, PageController;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';

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
      titleString: 'Appearance',
      contentPadding: EdgeInsets.all(gap),
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
            '${newSelection.first}',
            name: 'Settings: ThemeAppearanceTile',
          );
          writeAppearance(ref.watch(appearanceProvider));
          getSystemUIOverlayStyle(
            context.theme,
            ref.watch(appearanceProvider),
          );
        },
      ),
    );
  }
}
