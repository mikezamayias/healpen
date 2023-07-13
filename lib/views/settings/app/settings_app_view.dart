import 'package:flutter/material.dart' hide AppBar, ListTile, PageController;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../extensions/widget_extenstions.dart';
import '../../../utils/constants.dart';
import '../../../widgets/app_bar.dart';
import '../../blueprint/blueprint_view.dart';
import 'widgets/theme_appearance_tile.dart';
import 'widgets/theme_color_tile.dart';

class SettingsAppView extends ConsumerWidget {
  const SettingsAppView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Widget> pageWidgets = [
      const ThemeColorTile(),
      const ThemeAppearanceTile(),
    ].animateWidgetList();

    return BlueprintView(
      appBar: const AppBar(
        pathNames: [
          'Settings',
          'App',
        ],
      ),
      body: Wrap(
        spacing: gap,
        runSpacing: gap,
        children: pageWidgets,
      ),
    );
  }
}
