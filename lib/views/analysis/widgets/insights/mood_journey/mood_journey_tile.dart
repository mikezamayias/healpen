import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../controllers/analysis_view_controller.dart';
import '../../../../../models/analysis/analysis_model.dart';
import 'widgets/month_line_chart.dart';

class MoodJourneyTile extends ConsumerWidget {
  const MoodJourneyTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analysisModelList =
        ref.watch(AnalysisViewController.analysisModelListProvider);
    final monthSet = getMonthsFromAnalysisModelList(analysisModelList);
    return SingleChildScrollView(
      reverse: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ...monthSet
              .toList()
              .map((DateTime month) => MonthLineChart(month: month)),
        ],
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
