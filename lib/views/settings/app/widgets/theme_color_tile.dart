import 'dart:developer';

import 'package:flutter/material.dart' hide AppBar, ListTile, PageController;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../enums/app_theming.dart';
import '../../../../extensions/widget_extenstions.dart';
import '../../../../providers/settings_providers.dart';
import '../../../../utils/constants.dart';
import '../../../../widgets/custom_list_tile.dart';

class ThemeColorTile extends ConsumerWidget {
  const ThemeColorTile({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomListTile(
      titleString: 'Color',
      subtitle: Wrap(
        spacing: gap,
        children: [
          for (AppColor appColor in AppColor.values)
            TextButton(
              onPressed: () {
                ref.watch(currentAppColorProvider.notifier).state = appColor;
                log(
                  ref.watch(currentAppColorProvider).toString(),
                  name: 'currentAppColorProvider',
                );
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  appColor.color,
                ),
                textStyle: MaterialStateProperty.all(
                    const TextStyle(color: Colors.white)),
                foregroundColor: MaterialStateProperty.all(
                  appColor.color.computeLuminance() > 0.5
                      ? Colors.black
                      : Colors.white,
                ),
              ),
              child: Text(appColor.name),
            )
        ].animateWidgetList(),
      ),
    );
  }
}
