import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../controllers/analysis_view_controller.dart';
import '../../../../controllers/emotional_echo_controller.dart';
import '../../../../models/analysis/analysis_model.dart';
import '../../../../providers/settings_providers.dart';
import '../../../../utils/helper_functions.dart';
import 'emotional_echo/active_tile.dart';

class EmotionalEchoTile extends ConsumerWidget {
  const EmotionalEchoTile({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    EmotionalEchoController.sentiment = ref
        .watch(AnalysisViewController.analysisModelListProvider)
        .map((AnalysisModel analysisModel) => analysisModel.sentiment!)
        .average;
    EmotionalEchoController.sentimentRatio =
        getSentimentRatio(EmotionalEchoController.sentiment);
    EmotionalEchoController.shapeColor = getSentimentShapeColor(
      EmotionalEchoController.sentimentRatio,
    );
    EmotionalEchoController.textColor = getSentimentTexColor(
      EmotionalEchoController.sentimentRatio,
    );
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onLongPress: () {
        vibrate(ref.watch(navigationEnableHapticFeedbackProvider), () {
          ref.watch(EmotionalEchoController.isPressedProvider.notifier).state =
              true;
        });
      },
      onLongPressEnd: (_) {
        vibrate(ref.watch(navigationEnableHapticFeedbackProvider), () {
          ref.watch(EmotionalEchoController.isPressedProvider.notifier).state =
              false;
        });
      },
      child: const EmotionalEchoActiveTile(),
    );
  }
}
