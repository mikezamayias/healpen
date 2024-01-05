import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';

import '../../../controllers/writing_controller.dart';
import '../../../extensions/widget_extensions.dart';
import '../../../providers/settings_providers.dart';
import '../../../utils/constants.dart';
import 'bare_text_field.dart';
import 'stopwatch_tile.dart';
import 'writing_actions_tile.dart';

class WritingTextField extends ConsumerWidget {
  const WritingTextField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final useSmallNavigationElements =
        ref.watch(navigationSmallerNavigationElementsProvider);
    final isKeyboardOpen =
        ref.watch(WritingController().isKeyboardOpenProvider);
    final borderRadius = !isKeyboardOpen ? radius : gap;
    final color = !isKeyboardOpen && !useSmallNavigationElements
        ? context.theme.colorScheme.surfaceVariant
        : context.theme.colorScheme.surface;
    final padding = !isKeyboardOpen && !useSmallNavigationElements
        ? EdgeInsets.all(gap)
        : EdgeInsets.zero;
    return SafeArea(
      top: isKeyboardOpen,
      child: AnimatedContainer(
        duration: standardDuration,
        curve: standardCurve,
        decoration: isKeyboardOpen
            ? BoxDecoration(
                color: color,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(radius),
                  topRight: Radius.circular(radius),
                ),
              )
            : BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(borderRadius),
              ),
        padding: padding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Expanded(child: BareTextField()),
            const StopwatchTile(),
            const WritingActionsTile(),
          ].addSpacer(
            SizedBox(height: gap),
            spacerAtEnd: false,
            spacerAtStart: false,
          ),
        ),
      ),
    );
  }
}
