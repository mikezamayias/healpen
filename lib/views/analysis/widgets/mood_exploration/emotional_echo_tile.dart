import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:rive/rive.dart';

import '../../../../controllers/analysis_view_controller.dart';
import '../../../../extensions/number_extensions.dart';
import '../../../../models/analysis/analysis_model.dart';
import '../../../../utils/constants.dart';

class EmotionalEchoTile extends ConsumerWidget {
  const EmotionalEchoTile({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double averageSentimentValue = [
      for (AnalysisModel element
          in ref.watch(AnalysisViewController.analysisModelListProvider))
        element.sentiment!,
    ].average().toDouble();
    return Column(
      children: [
        Expanded(
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
                          shape.fills.first.paint.color = context
                              .theme.colorScheme.primary
                              .withOpacity(0.25);
                        }
                      },
                    );
                  },
                ),
                Text(
                  getSentimentLabel(averageSentimentValue)
                      .split(' ')
                      .join('\n'),
                  style: context.theme.textTheme.titleLarge!.copyWith(
                    color: context.theme.colorScheme.onPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
