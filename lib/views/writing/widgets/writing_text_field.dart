import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';

import '../../../controllers/writing_controller.dart';
import '../../../extensions/widget_extensions.dart';
import '../../../providers/settings_providers.dart';
import '../../../utils/constants.dart';
import 'bare_text_field.dart';
import 'stopwatch_tile.dart';
import 'writing_actions_button.dart';

class WritingTextField extends ConsumerStatefulWidget {
  const WritingTextField({super.key});

  @override
  ConsumerState<WritingTextField> createState() => _WritingTextFieldState();
}

class _WritingTextFieldState extends ConsumerState<WritingTextField> {
  @override
  Widget build(BuildContext context) {
    final borderRadius =
        useSimpleUi || useSmallNavigationElements ? radius : radius - gap;
    final color = useSimpleUi || useSmallNavigationElements
        ? context.theme.colorScheme.surfaceVariant
        : context.theme.colorScheme.surface;
    return SafeArea(
      top: isKeyboardOpen,
      child: AnimatedContainer(
        duration: standardDuration,
        curve: standardCurve,
        decoration: isKeyboardOpen && useSimpleUi
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
        padding: EdgeInsets.all(gap),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Expanded(child: BareTextField()),
            if (useSimpleUi) ...[
              const StopwatchTile().animateSlideInFromBottom(),
              const WritingActionsButton().animateSlideInFromTop(),
            ],
          ].addSpacer(
            SizedBox(height: gap),
            spacerAtEnd: false,
            spacerAtStart: false,
          ),
        ),
      ),
    );
  }

  bool get useSmallNavigationElements =>
      ref.watch(navigationSmallerNavigationElementsProvider);

  bool get useSimpleUi => ref.watch(navigationSimpleUIProvider);

  bool get isKeyboardOpen =>
      ref.watch(WritingController().isKeyboardOpenProvider);
}
