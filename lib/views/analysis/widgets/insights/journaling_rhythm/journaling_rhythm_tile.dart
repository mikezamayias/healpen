import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../../controllers/analysis_view_controller.dart';
import '../../../../../extensions/date_time_extensions.dart';
import '../../../../../extensions/int_extensions.dart';
import '../../../../../models/analysis/analysis_model.dart';
import '../../../../../utils/constants.dart';
import 'widgets/week_line_chart.dart';

class JournalingRhythmTile extends ConsumerWidget {
  const JournalingRhythmTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analysisModelList =
        ref.watch(AnalysisViewController.analysisModelListProvider);
    final weekDates = initializeWeekDates(analysisModelList);
    log(
      '${weekDates.length}',
      name: 'JournalingRhythmTile:weekDates.length',
    );
    return SingleChildScrollView(
      reverse: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: weekDates.reversed.map<Widget>(
          (List<DateTime> week) {
            return Container(
              height: 18.h,
              padding: EdgeInsets.symmetric(vertical: gap),
              child: WeekLineChart(week: week),
            );
          },
        ).toList(),
      ),
    );
  }

  List<List<DateTime>> initializeWeekDates(
    List<AnalysisModel> analysisModelList,
  ) {
    final weekSet = getMonthsFromAnalysisModelList(analysisModelList).toList();
    final List<List<DateTime>> weekList = [];
    while (weekSet.isNotEmpty) {
      int remainingDays = weekSet.length >= 7 ? 7 : weekSet.length;
      weekList.add(weekSet.sublist(0, remainingDays).reversed.toList());
      weekSet.removeRange(0, remainingDays);
    }
    return weekList;
  }

  Set<DateTime> getMonthsFromAnalysisModelList(
    List<AnalysisModel> analysisModelList,
  ) {
    final lastAnalysisModelTimestamp =
        analysisModelList.last.timestamp.timestampToDateTime();
    final startOfTheMonthOfLastAnalysisModelTimestamp =
        lastAnalysisModelTimestamp.startOfMonth();
    log(
      DateFormat('yyyy MMMM dd').format(lastAnalysisModelTimestamp),
      name: 'JournalingRhythmTile:lastAnalysisModelTimestamp',
    );
    log(
      DateFormat('yyyy MMMM dd')
          .format(startOfTheMonthOfLastAnalysisModelTimestamp),
      name: 'JournalingRhythmTile:startOfTheMonthOfLastAnalysisModelTimestamp',
    );
    // go down one day at a time until the start of the month is reached
    List<DateTime> startOfWeekList = <DateTime>[
      for (DateTime dateIndex = lastAnalysisModelTimestamp;
          dateIndex.isAfter(startOfTheMonthOfLastAnalysisModelTimestamp);
          dateIndex = dateIndex.subtract(const Duration(days: 1)))
        dateIndex
    ];
    return startOfWeekList.toSet();
  }
}
