import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../controllers/analysis_view_controller.dart';
import '../../../../controllers/emotional_echo_controller.dart';
import '../../../../controllers/settings/preferences_controller.dart';
import '../../../../models/analysis/analysis_model.dart';
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
    EmotionalEchoController.shapeColor =
        getSentimentShapeColor(EmotionalEchoController.sentiment);
    EmotionalEchoController.textColor =
        getSentimentTexColor(EmotionalEchoController.sentiment);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onLongPress: () {
        vibrate(PreferencesController.navigationEnableHapticFeedback.value, () {
          ref.watch(EmotionalEchoController.isPressedProvider.notifier).state =
              true;
        });
      },
      onLongPressEnd: (_) {
        vibrate(PreferencesController.navigationEnableHapticFeedback.value, () {
          ref.watch(EmotionalEchoController.isPressedProvider.notifier).state =
              false;
        });
      },
      child: const EmotionalEchoActiveTile(),
    );
  }
}
