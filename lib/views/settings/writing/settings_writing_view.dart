import 'package:flutter/material.dart' hide AppBar, ListTile, PageController;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../controllers/analysis_view_controller.dart';
import '../../../extensions/widget_extensions.dart';
import '../../../providers/settings_providers.dart';
import '../../../utils/constants.dart';
import '../../../widgets/app_bar.dart';
import '../../blueprint/blueprint_view.dart';
import '../../simple/simple_blueprint_view.dart';
import '../../simple/widgets/simple_app_bar.dart';
import 'widgets/analyze_notes_tile.dart';
import 'widgets/enable_automatic_stopwatch_tile.dart';

class SettingsWritingView extends ConsumerWidget {
  const SettingsWritingView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Widget> pageWidgets = [
      const EnableAutomaticStopwatchTile(),
      if (ref.watch(analysisModelSetProvider).isEmpty) const AnalyzeNotesTile(),
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
              appBarTitleString: 'Writing',
            ),
            body: body,
          )
        : BlueprintView(
            appBar: const AppBar(
              automaticallyImplyLeading: true,
              pathNames: [
                'Settings',
                'Writing',
              ],
            ),
            body: body,
          );
  }
}
