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

class EmotionalEchoActiveTile extends ConsumerStatefulWidget {
  const EmotionalEchoActiveTile({super.key});

  @override
  ConsumerState<EmotionalEchoActiveTile> createState() =>
      _EmotionalEchoActiveTileState();
}

class _EmotionalEchoActiveTileState
    extends ConsumerState<EmotionalEchoActiveTile> {
  TextStyle get titleLargeStyle =>
      textTheme.titleLarge!.copyWith(fontWeight: FontWeight.w600);

  TextStyle get titleSmallStyle =>
      textTheme.titleSmall!.copyWith(fontWeight: FontWeight.w600);

  Color get background => theme.colorScheme.background;

  double get sentiment =>
      ref.watch(EmotionalEchoController.scoreProvider).withDecimalPlaces(2);

  bool get isActive => ref.watch(EmotionalEchoController.isPressedProvider);

  bool get enableInformatoryText => ref.watch(navigationShowInfoProvider);

  double get availableHeight => 39.h;

  double get normalizedSentiment => (sentiment + 1) / 2;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        _buildEmotionalEchoInactiveTile(),
        _buildAnimatedSentimentContainer(),
      ],
    );
  }

  Widget _buildEmotionalEchoInactiveTile() {
    return AnimatedPositioned(
      duration: standardDuration,
      curve: standardCurve,
      top: 0,
      bottom: 0,
      right: isActive ? -99.w : 0,
      left: 0,
      child: AnimatedPadding(
        duration: standardDuration,
        curve: standardCurve,
        padding: isActive
            ? EdgeInsets.symmetric(vertical: gap)
            : EdgeInsets.all(gap),
        child: const EmotionalEchoInactiveTile(),
      ),
    );
  }

  Widget _buildAnimatedSentimentContainer() {
    logger.i(
      '[EmotionalEchoActiveTile:sentiment] ${sentiment.toStringAsFixed(1)}',
    );
    return AnimatedPositioned(
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
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    background.withOpacity(1.0),
                    background.withOpacity(0.6),
                  ],
                  stops: const [0.0, 1.0],
                ),
              )
            : const BoxDecoration(),
        width: 51.w,
        child: Padding(
          padding: EdgeInsets.all(gap),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: sentimentLabels.reversed.map(scaleText).toList(),
          ),
        ),
      ),
    );
  }

  Text scaleText(String label) {
    int labelIndex = sentimentLabels.indexOf(label);
    final sentimentValue = sentimentValues.elementAt(labelIndex);
    final sentimentColor = getShapeColorOnSentiment(theme, label);
    return Text(
      enableInformatoryText ? '$sentimentValue, $label' : label,
      style: titleLargeStyle.copyWith(color: sentimentColor),
    );
  }
}
