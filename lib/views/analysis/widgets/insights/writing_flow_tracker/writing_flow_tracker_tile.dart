import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../../providers/settings_providers.dart';
import '../../../../../services/data_analysis_service.dart';
import '../../../../../utils/constants.dart';
import '../../../../../widgets/custom_list_tile.dart';
import '../../../../../widgets/loading_tile.dart';
import 'painters/clock_painter.dart';

class WritingFlowTrackerTile extends ConsumerWidget {
  const WritingFlowTrackerTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder<List<HourlyData>>(
      stream: DataAnalysisService().getHourlyData(),
      builder: (context, snapshot) => chooseWidget(snapshot, ref)
          .animate()
          .fade(duration: shortStandardDuration, curve: standardEasing),
    );
  }

  Widget chooseWidget(
    AsyncSnapshot<List<HourlyData>> snapshot,
    WidgetRef ref,
  ) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const LoadingTile(
        durationTitle: 'Loading',
      );
    }

    if (!snapshot.hasData || snapshot.data!.isEmpty) {
      return const CustomListTile(
        titleString: 'No data available',
      );
    }
    return Stack(
      children: [
        Center(
          child: ClipOval(
            child: AspectRatio(
              aspectRatio: 1,
              child: Container(
                color: ref.read(themeProvider).colorScheme.outlineVariant,
              ),
            ),
          ),
        ),
        Center(
          child: CustomPaint(
            painter: ClockPainter(snapshot.data!),
            size: Size.fromRadius(42.w),
          ),
        ),
      ],
    );
  }
}
