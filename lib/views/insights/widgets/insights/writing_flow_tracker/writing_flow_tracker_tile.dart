import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../../controllers/analysis_view_controller.dart';
import '../../../../../extensions/analysis_model_extensions.dart';
import '../../../../../providers/settings_providers.dart';
import '../../../../../utils/constants.dart';
import 'painters/clock_painter.dart';

class WritingFlowTrackerTile extends ConsumerWidget {
  const WritingFlowTrackerTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref
        .watch(AnalysisViewController.analysisModelListProvider)
        .hourlyAnalysis();
    return Padding(
      padding: ref.watch(navigationSmallerNavigationElementsProvider)
          ? EdgeInsets.zero
          : EdgeInsets.all(gap),
      child: Stack(
        children: [
          Center(
            child: ClipOval(
              child: AspectRatio(
                aspectRatio: 1,
                child: Container(
                  color: context.theme.colorScheme.surfaceVariant,
                ),
              ),
            ),
          ),
          Center(
            child: CustomPaint(
              size: Size.fromRadius(42.w),
              painter: ClockPainter(
                hourlyData: data,
                theme: context.theme,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
