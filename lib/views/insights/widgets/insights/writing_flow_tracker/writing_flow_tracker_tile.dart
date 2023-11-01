import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../../services/data_analysis_service.dart';
import '../../../../../utils/constants.dart';
import '../../../../../widgets/custom_list_tile.dart';
import 'painters/clock_painter.dart';

class WritingFlowTrackerTile extends ConsumerWidget {
  const WritingFlowTrackerTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder<List<HourlyData>>(
      stream: DataAnalysisService().getHourlyData(),
      builder: (context, snapshot) => chooseWidget(snapshot, context)
          .animate()
          .fade(duration: shortStandardDuration, curve: standardEasing),
    );
  }

  Widget chooseWidget(
    AsyncSnapshot<List<HourlyData>> snapshot,
    BuildContext context,
  ) {
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
                color: context.theme.colorScheme.surfaceVariant,
              ),
            ),
          ),
        ),
        Center(
          child: CustomPaint(
            size: Size.fromRadius(42.w),
            painter: ClockPainter(
              hourlyData: snapshot.data!,
              theme: context.theme,
            ),
          ),
        ),
      ],
    );
  }
}
