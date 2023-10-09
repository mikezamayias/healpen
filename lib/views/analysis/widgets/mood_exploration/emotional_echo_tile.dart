import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';

import '../../../../controllers/analysis_view_controller.dart';
import '../../../../controllers/emotional_echo_controller.dart';
import '../../../../extensions/number_extensions.dart';
import '../../../../models/analysis/analysis_model.dart';
import '../../../../utils/constants.dart';
import 'emotional_echo/active_tile.dart';

class EmotionalEchoTile extends ConsumerStatefulWidget {
  const EmotionalEchoTile({
    super.key,
  });

  @override
  ConsumerState<EmotionalEchoTile> createState() => _EmotionalEchoTileState();
}

class _EmotionalEchoTileState extends ConsumerState<EmotionalEchoTile> {
  @override
  Widget build(BuildContext context) {
    EmotionalEchoController.sentiment = [
      for (AnalysisModel element
          in ref.watch(AnalysisViewController.analysisModelListProvider))
        element.sentiment!,
    ].average().toDouble();
    EmotionalEchoController.sentimentRatio =
        EmotionalEchoController.sentiment + 3 / sentimentValues.length;
    EmotionalEchoController.goodColor = colorScheme.primary;
    EmotionalEchoController.badColor = colorScheme.error;
    EmotionalEchoController.onGoodColor = colorScheme.onPrimary;
    EmotionalEchoController.onBadColor = colorScheme.onError;
    EmotionalEchoController.shapeColor = Color.lerp(
      EmotionalEchoController.badColor,
      EmotionalEchoController.goodColor,
      EmotionalEchoController.sentimentRatio,
    )!;
    EmotionalEchoController.textColor = Color.lerp(
      EmotionalEchoController.onBadColor,
      EmotionalEchoController.onGoodColor,
      EmotionalEchoController.sentimentRatio,
    )!;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) {
        ref.watch(EmotionalEchoController.isPressedProvider.notifier).state =
            true;
      },
      onTapUp: (_) {
        ref.watch(EmotionalEchoController.isPressedProvider.notifier).state =
            false;
      },
      child: const EmotionalEchoActivetile(),
    );
  }
}
