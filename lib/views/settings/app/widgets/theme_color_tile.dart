import 'dart:developer';

import 'package:flutter/material.dart' hide AppBar, ListTile, PageController;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../controllers/app_theming_controller.dart';
import '../../../../enums/app_theming.dart';
import '../../../../utils/constants.dart';
import '../../../../widgets/custom_list_tile/custom_list_tile.dart';

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
              onPressed: () async {
                await ref
                    .read(AppColorController
                        .instance.appColorControllerProvider.notifier)
                    .updateAppColor(appColor);
                log(
                  ref
                      .watch(AppColorController
                          .instance.appColorControllerProvider)
                      .appColor
                      .toString(),
                  name: 'appColorControllerProvider',
                );
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
