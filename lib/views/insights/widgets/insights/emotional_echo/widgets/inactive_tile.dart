import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:rive/rive.dart';

import '../../../../../../controllers/emotional_echo_controller.dart';
import '../../../../../../utils/constants.dart';
import '../../../../../../utils/helper_functions.dart';

class EmotionalEchoInactiveTile extends ConsumerStatefulWidget {
  const EmotionalEchoInactiveTile({
    super.key,
    this.child,
  });

  final Widget? child;

  @override
  ConsumerState<EmotionalEchoInactiveTile> createState() =>
      _EmotionalEchoInactiveTileState();
}

class _EmotionalEchoInactiveTileState
    extends ConsumerState<EmotionalEchoInactiveTile> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        RiveAnimation.asset(
          'assets/rive/emotional_echo.riv',
          fit: BoxFit.contain,
          controllers: [
            SimpleAnimation('AllCircles-v2'),
          ],
          onInit: (Artboard artboard) {
            artboard.forEachComponent(
              (child) {
                if (child is Shape) {
                  final Shape shape = child;
                  shape.fills.first.paint.color = backgroundColor.withOpacity(
                    shape.fills.first.paint.color.opacity,
                  );
                }
              },
            );
          },
        ),
        Align(
          alignment: Alignment.center,
          child: widget.child ??
              TweenAnimationBuilder<double>(
                tween: Tween<double>(
                  begin: ref.watch(EmotionalEchoController.isPressedProvider)
                      ? 1
                      : 0,
                  end: ref.watch(EmotionalEchoController.isPressedProvider)
                      ? 0
                      : 1,
                ),
                duration: emphasizedDuration,
                curve: emphasizedCurve,
                builder: (BuildContext context, double value, Widget? child) {
                  return Transform.scale(
                    scale: value,
                    child: Opacity(
                      opacity: value,
                      child: Text(
                        getSentimentLabel(score).split(' ').join('\n'),
                        textAlign: TextAlign.center,
                        style: context.theme.textTheme.titleLarge!.copyWith(
                          color: onBackgroundColor,
                        ),
                      ),
                    ),
                  );
                },
              ),
        ),
      ],
    );
  }

  double get score => ref.watch(EmotionalEchoController.scoreProvider);

  Color get shapeColor => getShapeColorOnSentiment(context.theme, score);

  Color get textColor => getTextColorOnSentiment(context.theme, score);

  Color get backgroundColor =>
      context.mediaQuery.platformBrightness.isLight ? shapeColor : textColor;

  Color get onBackgroundColor =>
      context.mediaQuery.platformBrightness.isLight ? textColor : shapeColor;
}
