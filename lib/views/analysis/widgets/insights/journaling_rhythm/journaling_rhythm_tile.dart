import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../../controllers/analysis_view_controller.dart';
import '../../../../../models/analysis/analysis_model.dart';
import '../../../../../widgets/text_divider.dart';
import '../mood_journey/widgets/month_line_chart.dart';

class JournalingRhythmTile extends ConsumerWidget {
  const JournalingRhythmTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analysisModelList =
        ref.watch(AnalysisViewController.analysisModelListProvider);
    final monthSet = getMonthsFromAnalysisModelList(analysisModelList);
    return SingleChildScrollView(
      reverse: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: monthSet
            .map<Widget>(
              (DateTime month) => SizedBox(
                height: 30.h,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextDivider(
                      DateFormat('y, MMMM').format(month),
                    ),
                    Expanded(
                      child: MonthLineChart(month: month),
                    )
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Set<DateTime> getMonthsFromAnalysisModelList(
      List<AnalysisModel> analysisModelList) {
    List<DateTime> monthList = <DateTime>[];
    for (var analysisModel in analysisModelList) {
      var month = DateTime.fromMillisecondsSinceEpoch(
        analysisModel.timestamp,
      ).month;
      var year = DateTime.fromMillisecondsSinceEpoch(
        analysisModel.timestamp,
      ).year;
      monthList.add(DateTime(year, month));
    }
    return monthList.toSet();
  }
}
