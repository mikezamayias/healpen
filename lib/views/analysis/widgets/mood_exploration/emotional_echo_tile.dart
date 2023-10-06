import 'package:flutter/material.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:rive/rive.dart';

class EmotionalEchoTile extends StatelessWidget {
  const EmotionalEchoTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AspectRatio(
        aspectRatio: 1,
        child: Stack(
          alignment: Alignment.center,
          children: [
            RiveAnimation.asset(
              'assets/rive/emotional_echo.riv',
              animations: const ['AllCircles'],
              fit: BoxFit.fitHeight,
              onInit: (Artboard artboard) {
                artboard.forEachComponent(
                  (child) {
                    if (child is Shape) {
                      final Shape shape = child;
                      shape.fills.first.paint.color =
                          context.theme.colorScheme.primary.withOpacity(0.25);
                    }
                  },
                );
              },
            ),
            Text(
              'sentiment value',
              style: context.theme.textTheme.titleLarge!.copyWith(
                color: context.theme.colorScheme.onPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
