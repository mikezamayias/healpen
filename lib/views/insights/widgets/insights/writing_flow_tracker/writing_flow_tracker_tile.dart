import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../../providers/settings_providers.dart';
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
      builder: (context, snapshot) {
        return ((!snapshot.hasData || snapshot.data!.isEmpty)
                ? const CustomListTile(
                    titleString: 'No data available',
                  )
                : Padding(
                    padding:
                        ref.watch(navigationSmallerNavigationElementsProvider)
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
                              hourlyData: snapshot.data!,
                              theme: context.theme,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ))
            .animate()
            .fade(duration: shortStandardDuration, curve: standardEasing);
      },
    );
  }
}
