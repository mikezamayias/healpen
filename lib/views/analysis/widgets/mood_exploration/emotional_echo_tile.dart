import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../utils/constants.dart';

class EmotionalEchoTile extends ConsumerWidget {
  const EmotionalEchoTile({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: AspectRatio(
        aspectRatio: 1,
        child: Stack(
          alignment: Alignment.center,
          children: [
            RepaintBoundary(
              child: Container(
                margin: EdgeInsets.zero,
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(100.w),
                    border: Border.all(
                      color:
                          context.theme.colorScheme.primary.withOpacity(0.25),
                      width: gap * 4,
                    ),
                  ),
                )
                    .animate(
                      delay: standardDuration,
                      onPlay: (animationController) =>
                          animationController.loop(),
                    )
                    .scaleXY(
                      begin: 0.9,
                      duration: emphasizedDuration,
                      curve: emphasizedCurve,
                    )
                    .then(duration: longEmphasizedDuration)
                    .scaleXY(end: 0.9),
              ),
            ),
            RepaintBoundary(
              child: Container(
                margin: EdgeInsets.all(gap),
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(100.w),
                    border: Border.all(
                      color:
                          context.theme.colorScheme.primary.withOpacity(0.25),
                      width: gap * 3,
                    ),
                  ),
                )
                    .animate(
                      delay: standardDuration,
                      onPlay: (animationController) =>
                          animationController.loop(),
                    )
                    .scaleXY(
                      begin: 0.9,
                      duration: emphasizedDuration,
                      curve: emphasizedCurve,
                    )
                    .then(duration: longEmphasizedDuration)
                    .scaleXY(end: 0.9),
              ),
            ),
            RepaintBoundary(
              child: Container(
                margin: EdgeInsets.all(gap * 2),
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(100.w),
                    border: Border.all(
                      color:
                          context.theme.colorScheme.primary.withOpacity(0.25),
                      width: gap * 2,
                    ),
                  ),
                )
                    .animate(
                      delay: standardDuration,
                      onPlay: (animationController) =>
                          animationController.loop(),
                    )
                    .scaleXY(
                      begin: 0.9,
                      duration: emphasizedDuration,
                      curve: emphasizedCurve,
                    )
                    .then(duration: longEmphasizedDuration)
                    .scaleXY(end: 0.9),
              ),
            ),
            RepaintBoundary(
              child: Container(
                margin: EdgeInsets.all(gap * 3),
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: context.theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(100.w),
                    border: Border.all(
                      color:
                          context.theme.colorScheme.primary.withOpacity(0.25),
                      width: gap,
                    ),
                  ),
                )
                    .animate(
                      delay: standardDuration,
                      onPlay: (animationController) =>
                          animationController.loop(),
                    )
                    .scaleXY(
                      begin: 0.9,
                      duration: emphasizedDuration,
                      curve: emphasizedCurve,
                    )
                    .then(duration: longEmphasizedDuration)
                    .scaleXY(end: 0.9),
              ),
            ),
            Text(
              'sentiment value',
              style: context.theme.textTheme.titleLarge!.copyWith(
                color: context.theme.colorScheme.onPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChartData {
  ChartData(this.x, this.y);

  final String x;
  final double y;
}
