import 'package:flutter/material.dart' hide AppBar, ListTile, PageController;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../extensions/widget_extensions.dart';
import '../../../utils/constants.dart';
import '../../../widgets/app_bar.dart';
import '../../blueprint/blueprint_view.dart';
import 'widgets/writing_stopwatch_tile.dart';

class SettingsWritingView extends ConsumerWidget {
  const SettingsWritingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Widget> pageWidgets = [
      const WritingStopwatchTile(),
    ].animateWidgetList();

    return BlueprintView(
      appBar: const AppBar(
        automaticallyImplyLeading: true,
        pathNames: [
          'Settings',
          'Writing',
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
