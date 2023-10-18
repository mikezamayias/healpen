import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../../../controllers/emotional_echo_controller.dart';
import '../../../../../../providers/settings_providers.dart';
import '../../../../../../utils/constants.dart';
import 'inactive_tile.dart';

class EmotionalEchoActiveTile extends ConsumerWidget {
  const EmotionalEchoActiveTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<String> labels = [
      ...sentimentLabels.map(
        (String label) {
          return '${sentimentValues[sentimentLabels.indexOf(label)]}, $label';
        },
      )
    ];
    return Stack(
      children: <Widget>[
        AnimatedPositioned(
          duration: emphasizedDuration,
          curve: emphasizedCurve,
          top: 0,
          bottom: 0,
          left: 0,
          right:
              ref.watch(EmotionalEchoController.isPressedProvider) ? -102.w : 0,
          child: const EmotionalEchoInactiveTile(),
        ),
        AnimatedPositioned(
          duration: emphasizedDuration,
          curve: emphasizedCurve,
          top: 0,
          bottom: 0,
          left:
              ref.watch(EmotionalEchoController.isPressedProvider) ? 0 : -51.w,
          right: 0,
          child: SizedBox(
            width: 51.w,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  width: gap,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(radius),
                    gradient: LinearGradient(
                      colors: <Color>[
                        ref.watch(themeProvider).colorScheme.primary,
                        ref.watch(themeProvider).colorScheme.error,
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
                    children: labels.reversed.map(
                      (String label) {
                        return Text(
                          label,
                          style: context.theme.textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Color.lerp(
                              ref.watch(themeProvider).colorScheme.error,
                              ref.watch(themeProvider).colorScheme.primary,
                              labels.indexOf(label) / labels.length,
                            )!,
                          ),
                        );
                      },
                    ).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
