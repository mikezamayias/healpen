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
      subtitle: Wrap(
        spacing: gap,
        children: [
          for (AppColor appColor in AppColor.values)
            TextButton(
              onPressed: () async {
                ref.watch(appColorProvider.notifier).state = appColor;
                log(
                  'Theme Color changed to $appColor',
                  name: 'Settings: ThemeAppearanceTile',
                );
                log(
                  ref.watch(appColorProvider).toString(),
                  name: 'ref.watch(appColorProvider).toString()',
                );
                writeAppColor(ref.watch(appColorProvider));
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  appColor.color,
                ),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(gap),
                    ),
                  ),
                ),
                textStyle: MaterialStateProperty.all(
                  const TextStyle(color: Colors.white),
                ),
                foregroundColor: MaterialStateProperty.all(
                  appColor.color.computeLuminance() > 0.5
                      ? Colors.black
                      : Colors.white,
                ),
              ),
              child: Text(appColor.name),
            )
        ],
      ),
    );
  }
}
