import 'package:flutter/material.dart' hide AppBar, ListTile, PageController;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../extensions/widget_extensions.dart';
import '../../../utils/constants.dart';
import '../../../widgets/app_bar.dart';
import '../../../widgets/text_divider.dart';
import '../../blueprint/blueprint_view.dart';
import 'widgets/haptic_feedback_settings_tile.dart';
import 'widgets/hide_app_bar_title.dart';
import 'widgets/navigation_settings_tile.dart';
import 'widgets/theme_appearance_tile.dart';
import 'widgets/theme_color_tile.dart';
import 'widgets/writing_stopwatch_tile.dart';

class SettingsAppView extends ConsumerWidget {
  const SettingsAppView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Widget> pageWidgets = [
      const TextDivider('Theme'),
      const ThemeColorTile(),
      const ThemeAppearanceTile(),
      const TextDivider('Writing'),
      const WritingStopwatchTile(),
      const TextDivider('Navigation'),
      const EnableBackButtonSettingsTile(),
      const ReduceHapticFeedbackSettingsTile(),
      const HideAppBarTitle(),
    ].animateWidgetList();

    return BlueprintView(
      appBar: const AppBar(
        automaticallyImplyLeading: true,
        pathNames: [
          'Settings',
          'App',
        ],
      ),
      body: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: SingleChildScrollView(
          clipBehavior: Clip.hardEdge,
          child: Wrap(
            spacing: gap,
            runSpacing: gap,
            children: pageWidgets,
          ),
        ),
      ),
    );
  }
}
