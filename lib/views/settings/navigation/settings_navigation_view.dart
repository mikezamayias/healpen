import 'package:flutter/material.dart' hide AppBar, ListTile, PageController;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../extensions/widget_extensions.dart';
import '../../../../utils/constants.dart';
import '../../../widgets/app_bar.dart';
import '../../blueprint/blueprint_view.dart';
import 'widgets/show_app_bar_tile.dart';
import 'widgets/back_button_settings_tile.dart';
import 'widgets/haptic_feedback_settings_tile.dart';
import 'widgets/info_button_settings_tile.dart';
import 'widgets/smaller_navigation_elements_tile.dart';

class SettingsNavigationView extends ConsumerWidget {
  const SettingsNavigationView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Widget> pageWidgets = const [
      ShowAppBarTile(),
      BackButtonSettingsTile(),
      SmallerNavigationElementsTile(),
      HapticFeedbackSettingsTile(),
      InfoButtonSettingsTile(),
    ].animateWidgetList();

    return BlueprintView(
      showAppBar: true,
      appBar: const AppBar(
        automaticallyImplyLeading: true,
        pathNames: [
          'Settings',
          'Navigation',
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
