import 'package:flutter/material.dart' hide AppBar, ListTile, PageController;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../extensions/widget_extenstions.dart';
import '../../../utils/constants.dart';
import '../../../widgets/app_bar.dart';
import '../../blueprint/blueprint_view.dart';
import 'widgets/theme_color_tile.dart';

class SettingsAppView extends ConsumerWidget {
  const SettingsAppView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Widget> pageWidgets = [
      const ThemeColorTile(),
    ].animateWidgetList();

    return BlueprintView(
      appBar: const AppBar(
        pathNames: ['Settings', 'App'],
      ),
      body: ListView.separated(
        clipBehavior: Clip.none,
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemBuilder: (_, int index) => pageWidgets[index],
        separatorBuilder: (_, __) => SizedBox(height: gap * 2),
        itemCount: pageWidgets.length,
      ),
    );
  }
}
