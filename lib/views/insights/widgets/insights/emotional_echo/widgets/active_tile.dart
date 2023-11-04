import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../../../controllers/analysis_view_controller.dart';
import '../../../../../../controllers/emotional_echo_controller.dart';
import '../../../../../../providers/settings_providers.dart';
import '../../../../../../utils/constants.dart';
import '../../../../../../utils/helper_functions.dart';
import 'inactive_tile.dart';

class EmotionalEchoActiveTile extends ConsumerWidget {
  const EmotionalEchoActiveTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double sentiment = ref
        .watch(AnalysisViewController.analysisModelListProvider)
        .map((e) => e.score)
        .average;
    num closestIndexSentiment = getClosestSentimentIndex(sentiment);
    return Padding(
      padding: ref.watch(navigationSmallerNavigationElementsProvider)
          ? EdgeInsets.zero
          : EdgeInsets.all(gap),
      child: Stack(
        children: <Widget>[
          AnimatedPositioned(
            duration: emphasizedDuration,
            curve: emphasizedCurve,
            top: 0,
            bottom: 0,
            left: 0,
            right: ref.watch(EmotionalEchoController.isPressedProvider)
                ? -102.w
                : 0,
            child: const EmotionalEchoInactiveTile(),
          ),
          AnimatedPositioned(
            duration: emphasizedDuration,
            curve: emphasizedCurve,
            top: 0,
            bottom: 0,
            left: ref.watch(EmotionalEchoController.isPressedProvider)
                ? 0
                : -51.w,
            right: 0,
            child: SizedBox(
              width: 51.w,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: sentimentLabels.reversed.map(
                  (String label) {
                    int labelIndex = sentimentLabels.indexOf(label);
                    return Text(
                      label,
                      style: (labelIndex == closestIndexSentiment
                              ? context.theme.textTheme.titleLarge
                              : context.theme.textTheme.titleMedium)!
                          .copyWith(
                        fontWeight: labelIndex == closestIndexSentiment
                            ? FontWeight.w900
                            : FontWeight.w600,
                        color: getShapeColorOnSentiment(context, label),
                      ),
                    );
                  },
                ).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
