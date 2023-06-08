import 'dart:developer';

import 'package:flutter/material.dart' hide AppBar, ListTile, PageController;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';

import '../../controllers/page_controller.dart';
import '../../enums/app_theming.dart';
import '../../extensions/widget_extenstions.dart';
import '../../providers/settings_providers.dart';
import '../../utils/constants.dart';
import '../../widgets/app_bar.dart';
import '../blueprint/blueprint_view.dart';

class SettingsView extends ConsumerWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BlueprintView(
      appBar: AppBar(
        pageModel: PageController().settings,
      ),
      body: Column(
        children: [
          Expanded(
            child: Wrap(
              spacing: gap,
              children: [
                for (AppColor appColor in AppColor.values)
                  TextButton(
                    onPressed: () {
                      ref.watch(currentAppColorProvider.notifier).state =
                          appColor;
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
              ],
            ),
          ),
          const Spacer(flex: 2),
          Expanded(
            child: Card(
              child: Center(
                child: Text(
                  ref.watch(currentAppColorProvider).name,
                  style: context.theme.textTheme.displaySmall!.copyWith(
                    color: context.theme.cardTheme.color?.computeLuminance() !=
                            null
                        ? context.theme.cardTheme.color!.computeLuminance() >
                                0.5
                            ? Colors.black
                            : Colors.white
                        : Colors.white,
                  ),
                ),
              ),
            ),
          )
        ].animateWidgetList(),
      ),
    );
  }
}
