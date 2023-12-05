import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../../../controllers/emotional_echo_controller.dart';
import '../../../../../../extensions/double_extensions.dart';
import '../../../../../../providers/settings_providers.dart';
import '../../../../../../utils/constants.dart';
import '../../../../../../utils/helper_functions.dart';
import '../../../../../../utils/logger.dart';
import 'inactive_tile.dart';

class EmotionalEchoActiveTile extends ConsumerWidget {
  const EmotionalEchoActiveTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double sentiment = ref
        .watch(emotionalEchoControllerProvider)
        .sentimentScore
        .withDecimalPlaces(1);
    logger.i(
      '[EmotionalEchoActiveTile:sentiment] ${sentiment.toStringAsFixed(1)}',
    );
    final sentimentLadder = sentimentValueToLabel
      ..addAll({sentiment.withDecimalPlaces(1): 'Current Mood'});
    // Sort the map by key.
    final sortedSentimentLadder = Map.fromEntries(
      sentimentLadder.entries.toList()
        ..sort((MapEntry<num, String> a, MapEntry<num, String> b) =>
            b.key.compareTo(a.key)),
    );
    final isActive = ref.watch(EmotionalEchoController.isPressedProvider);
    final enableInformatoryText = ref.watch(navigationShowInfoProvider);
    return Stack(
      children: <Widget>[
        AnimatedPositioned(
          duration: standardDuration,
          curve: standardCurve,
          top: 0,
          bottom: 0,
          right: isActive ? -99.w : 0,
          left: 0,
          child: const EmotionalEchoInactiveTile(),
        ),
        AnimatedPositioned(
          duration: standardDuration,
          curve: standardCurve,
          top: 0,
          bottom: 0,
          left: isActive ? 0 : -71.w,
          right: 0,
          child: AnimatedContainer(
            duration: standardDuration,
            curve: standardCurve,
            decoration: isActive
                ? BoxDecoration(
                    gradient: isActive
                        ? LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              context.theme.colorScheme.background
                                  .withOpacity(1.0),
                              context.theme.colorScheme.background
                                  .withOpacity(0.0),
                            ],
                            stops: const [0.0, 1.0],
                          )
                        : null,
                  )
                : const BoxDecoration(),
            width: 51.w,
            child: Stack(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: sortedSentimentLadder.keys.map(
                    (num key) {
                      return Visibility(
                        visible: key == sentiment,
                        child: Text(
                          enableInformatoryText
                              ? '${key.toStringAsFixed(1)}, ${sortedSentimentLadder[key]}'
                              : '${sortedSentimentLadder[key]}',
                          style: context.theme.textTheme.titleLarge!.copyWith(
                            fontWeight: FontWeight.w600,
                            color: getShapeColorOnSentiment(
                              context.theme,
                              key,
                            ),
                          ),
                        ),
                      );
                    },
                  ).toList(),
                ),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: sentimentLabels.reversed.map(
                    (String label) {
                      int labelIndex = sentimentLabels.indexOf(label);
                      return Text(
                        enableInformatoryText
                            ? '${sentimentValues.elementAt(labelIndex)}, $label'
                            : label,
                        style: context.theme.textTheme.titleSmall!.copyWith(
                          fontWeight: FontWeight.w600,
                          color: getShapeColorOnSentiment(context.theme, label),
                        ),
                      );
                    },
                  ).toList(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
