import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../../controllers/emotional_echo_controller.dart';
import '../../../../../utils/constants.dart';
import 'inactive_tile.dart';

class EmotionalEchoActivetile extends ConsumerWidget {
  const EmotionalEchoActivetile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      children: <Widget>[
        AnimatedPositioned(
          duration: emphasizedDuration,
          curve: emphasizedCurve,
          top: 0,
          bottom: 0,
          left:
              ref.watch(EmotionalEchoController.isPressedProvider) ? 0 : -48.w,
          right: 0,
          child: Container(
            width: 48.w,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: <Color>[
                  context.theme.colorScheme.surface,
                  context.theme.colorScheme.surface.withOpacity(0.3),
                  context.theme.colorScheme.surface.withOpacity(0),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                stops: const [0.0, 0.3, 0.5],
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Container(
                  width: gap,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(radius),
                    gradient: LinearGradient(
                      colors: <Color>[
                        EmotionalEchoController.goodColor,
                        EmotionalEchoController.badColor,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
                Gap(gap),
                Flexible(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ...sentimentLabels
                          .map(
                            (String label) => Text(
                              label,
                              style:
                                  context.theme.textTheme.bodyMedium!.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Color.lerp(
                                  EmotionalEchoController.badColor,
                                  EmotionalEchoController.goodColor,
                                  sentimentLabels.indexOf(label) /
                                      sentimentLabels.length,
                                )!,
                              ),
                            ),
                          )
                          .toList()
                          .reversed,
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        AnimatedPositioned(
          duration: emphasizedDuration,
          curve: emphasizedCurve,
          top: 0,
          bottom: 0,
          left: 0,
          right:
              ref.watch(EmotionalEchoController.isPressedProvider) ? -81.w : 0,
          child: const EmotionalEchoInactiveTile(),
        ),
      ],
    );
  }
}
