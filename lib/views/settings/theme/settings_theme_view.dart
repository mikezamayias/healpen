import 'package:flutter/material.dart' hide AppBar, ListTile, PageController;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../utils/constants.dart';
import '../../../extensions/widget_extensions.dart';
import '../../../widgets/app_bar.dart';
import '../../blueprint/blueprint_view.dart';
import 'widgets/colorize_on_sentiment_tile.dart';
import 'widgets/theme_appearance_tile.dart';
import 'widgets/theme_color_tile.dart';

class SettingsThemeView extends ConsumerWidget {
  const SettingsThemeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Widget> pageWidgets = [
      const ThemeColorTile(),
      const ThemeAppearanceTile(),
      const ColorizeOnSentimentTile(),
    ].animateWidgetList();
    Widget body = ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: SingleChildScrollView(
        clipBehavior: Clip.hardEdge,
        child: Wrap(
          spacing: gap,
          runSpacing: gap,
          children: pageWidgets,
        ),
      ),
    );

    return BlueprintView(
      appBar: const AppBar(
        automaticallyImplyLeading: true,
        pathNames: [
          'Settings',
          'Theme',
        ],
      ),
      body: body,
    );
  }
}
