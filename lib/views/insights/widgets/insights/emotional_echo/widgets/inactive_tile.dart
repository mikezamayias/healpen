import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:rive/rive.dart';

import '../../../../../../controllers/emotional_echo_controller.dart';
import '../../../../../../utils/constants.dart';
import '../../../../../../utils/helper_functions.dart';

class EmotionalEchoInactiveTile extends ConsumerWidget {
  const EmotionalEchoInactiveTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double sentiment =
        ref.watch(emotionalEchoControllerProvider).sentimentScore;
    Color shapeColor = getShapeColorOnSentiment(context.theme, sentiment);
    Color textColor = getTextColorOnSentiment(context.theme, sentiment);
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        RiveAnimation.asset(
          'assets/rive/emotional_echo.riv',
          fit: BoxFit.contain,
          controllers: [
            SimpleAnimation('AllCircles'),
          ],
          onInit: (Artboard artboard) {
            artboard.forEachComponent(
              (child) {
                if (child is Shape) {
                  final Shape shape = child;
                  shape.fills.first.paint.color = shapeColor.withOpacity(
                    shape.fills.first.paint.color.opacity,
                  );
                }
              },
            );
          },
        ),
        Align(
          alignment: Alignment.center,
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(
              begin:
                  ref.watch(EmotionalEchoController.isPressedProvider) ? 1 : 0,
              end: ref.watch(EmotionalEchoController.isPressedProvider) ? 0 : 1,
            ),
            duration: emphasizedDuration,
            curve: emphasizedCurve,
            builder: (BuildContext context, double value, Widget? child) {
              return Transform.scale(
                scale: value,
                child: Opacity(
                  opacity: value,
                  child: Text(
                    getSentimentLabel(sentiment).split(' ').join('\n'),
                    textAlign: TextAlign.center,
                    style: context.theme.textTheme.titleLarge!.copyWith(
                      color: textColor,
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
}
