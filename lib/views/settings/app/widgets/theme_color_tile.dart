import 'dart:developer';

import 'package:flutter/material.dart' hide AppBar, ListTile, PageController;
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
      titleString: 'Color',
      contentPadding: EdgeInsets.all(gap),
      enableSubtitleWrapper: false,
      subtitle: SegmentedButton<AppColor>(
        showSelectedIcon: false,
        segments: <ButtonSegment<AppColor>>[
          for (AppColor appColor in AppColor.values)
            ButtonSegment(
              value: appColor,
              label: Text(appColor.name),
            ),
        ],
        selected: {ref.watch(appColorProvider)},
        onSelectionChanged: (Set<AppColor> newSelection) {
          ref.watch(appColorProvider.notifier).state = newSelection.first;
          log(
            '${newSelection.first}',
            name: 'Settings: ThemeAppearanceTile',
          );
          writeAppColor(ref.watch(appColorProvider));
        },
      ),
    );
  }
}
