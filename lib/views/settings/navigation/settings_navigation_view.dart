import 'package:flutter/material.dart' hide AppBar, ListTile, PageController;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../extensions/widget_extensions.dart';
import '../../../../utils/constants.dart';
import '../../../providers/settings_providers.dart';
import '../../../widgets/app_bar.dart';
import '../../blueprint/blueprint_view.dart';
import '../../simple/simple_blueprint_view.dart';
import '../../simple/widgets/simple_app_bar.dart';
import 'widgets/back_button_settings_tile.dart';
import 'widgets/enable_info_settings_tile.dart';
import 'widgets/enable_simple_ui_tile.dart';
import 'widgets/haptic_feedback_settings_tile.dart';
import 'widgets/show_app_bar_tile.dart';
import 'widgets/smaller_navigation_elements_tile.dart';

class SettingsNavigationView extends ConsumerWidget {
  const SettingsNavigationView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Widget> pageWidgets = const [
      EnableSimpleUiTile(),
      HapticFeedbackSettingsTile(),
      EnableInfoSettingsTile(),
      ShowAppBarTile(),
      BackButtonSettingsTile(),
      SmallerNavigationElementsTile(),
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

    return ref.watch(navigationSimpleUIProvider)
        ? SimpleBlueprintView(
            simpleAppBar: const SimpleAppBar(
              appBarTitleString: 'Navigation',
            ),
            body: body,
          )
        : BlueprintView(
            appBar: const AppBar(
              automaticallyImplyLeading: true,
              pathNames: <String>[
                'Settings',
                'Navigation',
              ],
            ),
            body: body,
          );
  }
}
