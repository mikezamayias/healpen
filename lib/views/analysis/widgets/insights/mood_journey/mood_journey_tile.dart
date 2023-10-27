import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../../controllers/analysis_view_controller.dart';
import '../../../../../extensions/analysis_model_extensions.dart';
import '../../../../../widgets/text_divider.dart';
import 'widgets/month_line_chart.dart';

class MoodJourneyTile extends ConsumerWidget {
  const MoodJourneyTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final monthSet = ref
        .watch(AnalysisViewController.analysisModelListProvider)
        .getMonthsFromAnalysisModelList();
    return SingleChildScrollView(
      reverse: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: monthSet.map<Widget>(
          (DateTime month) {
            return SizedBox(
              height: 36.h,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextDivider(
                    DateFormat('y, MMMM').format(month),
                  ),
                  Expanded(
                    child: MonthLineChart(month),
                  )
                ],
              ),
            );
          },
        ).toList(),
      ),
    );
  }
}
