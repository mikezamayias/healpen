import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:rive/rive.dart' hide LinearGradient;

import '../../../../controllers/analysis_view_controller.dart';
import '../../../../extensions/number_extensions.dart';
import '../../../../models/analysis/analysis_model.dart';
import '../../../../utils/constants.dart';

class EmotionalEchoTile extends ConsumerStatefulWidget {
  const EmotionalEchoTile({
    super.key,
  });

  @override
  ConsumerState<EmotionalEchoTile> createState() => _EmotionalEchoTileState();
}

class _EmotionalEchoTileState extends ConsumerState<EmotionalEchoTile> {
  bool longPress = false;
  @override
  Widget build(BuildContext context) {
    double averageSentimentValue = [
      for (AnalysisModel element
          in ref.watch(AnalysisViewController.analysisModelListProvider))
        element.sentiment!,
    ].average().toDouble();

    log(averageSentimentValue.toString(), name: 'averageSentimentValue');

    double sentimentRatio = averageSentimentValue + 3 / sentimentValues.length;
    Color goodColor = context.colorScheme.primary;
    Color onGoodColor = context.colorScheme.onPrimary;
    Color badColor = context.colorScheme.error;
    Color onBadColor = context.colorScheme.onError;

    Color shapeColor = Color.lerp(
      goodColor,
      badColor,
      sentimentRatio,
    )!;
    Color textColor = Color.lerp(
      onGoodColor,
      onBadColor,
      sentimentRatio,
    )!;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onLongPress: () {
        setState(() {
          longPress = true;
        });
      },
      onLongPressEnd: (_) {
        setState(() {
          longPress = false;
        });
      },
      child: Stack(
        alignment: Alignment.centerRight,
        children: <Widget>[
          SizedBox(
            width: 60.w,
            child: Stack(
              children: <Widget>[
                RiveAnimation.asset(
                  'assets/rive/emotional_echo.riv',
                  stateMachines: const [
                    'AllCircles',
                  ],
                  fit: BoxFit.contain,
                  alignment: Alignment.centerRight,
                  onInit: (Artboard artboard) {
                    artboard.forEachComponent(
                      (child) {
                        if (child is Shape) {
                          final Shape shape = child;
                          shape.fills.first.paint.color =
                              shapeColor.withOpacity(
                                  shape.fills.first.paint.color.opacity);
                        }
                      },
                    );
                  },
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    getSentimentLabel(averageSentimentValue),
                    style: context.theme.textTheme.titleLarge!.copyWith(
                      color: textColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: <Widget>[
              Container(
                width: gap,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(radius),
                  gradient: LinearGradient(
                    colors: <Color>[
                      goodColor,
                      badColor,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
              Gap(gap),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: longPress
                      ? <Widget>[
                          ...sentimentLabels.map(
                            (String label) => Text(
                              label,
                              style:
                                  context.theme.textTheme.bodyMedium!.copyWith(
                                color: textColor,
                              ),
                            ),
                          ),
                        ]
                      : <Widget>[
                          Text(
                            sentimentLabels.last,
                            style: context.theme.textTheme.bodyMedium!.copyWith(
                              color: goodColor,
                            ),
                          ),
                          Text(
                            sentimentLabels.first,
                            style: context.theme.textTheme.bodyMedium!.copyWith(
                              color: badColor,
                            ),
                          ),
                        ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
