import 'package:flutter/material.dart' hide AppBar, ListTile, PageController;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../extensions/widget_extensions.dart';
import '../../../providers/settings_providers.dart';
import '../../../utils/constants.dart';
import '../../../widgets/app_bar.dart';
import '../../blueprint/blueprint_view.dart';
import '../../simple/simple_blueprint_view.dart';
import '../../simple/widgets/simple_app_bar.dart';
import 'widgets/reorder_insights_tile.dart';

class SettingsInsightsView extends ConsumerWidget {
  const SettingsInsightsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Widget> pageWidgets = [
      const ReorderInsightsTile(),
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
              appBarTitleString: 'Insights',
            ),
            body: body,
          )
        : BlueprintView(
            appBar: const AppBar(
              automaticallyImplyLeading: true,
              pathNames: [
                'Settings',
                'Insights',
              ],
            ),
            body: body,
          );
  }
}
