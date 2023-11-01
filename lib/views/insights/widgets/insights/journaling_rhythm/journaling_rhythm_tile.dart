import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../../controllers/analysis_view_controller.dart';
import '../../../../../extensions/date_time_extensions.dart';
import '../../../../../extensions/int_extensions.dart';
import '../../../../../models/analysis/analysis_model.dart';
import '../../../../../widgets/text_divider.dart';
import 'widgets/week_line_chart.dart';

class JournalingRhythmTile extends ConsumerStatefulWidget {
  const JournalingRhythmTile({super.key});

  @override
  ConsumerState<JournalingRhythmTile> createState() =>
      _JournalingRhythmTileState();
}

class _JournalingRhythmTileState extends ConsumerState<JournalingRhythmTile> {
  late List<List<DateTime>> weekDates;

  @override
  Widget build(BuildContext context) {
    weekDates = initializeWeekDates(
      ref.watch(AnalysisViewController.analysisModelListProvider),
    );
    return SingleChildScrollView(
      reverse: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: weekDates.reversed.map<Widget>(
          (List<DateTime> week) {
            return SizedBox(
              height: 24.h,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextDivider(chartTitle(week)),
                  Expanded(
                    child: WeekLineChart(week),
                  )
                ],
              ),
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
        analysisModelList.last.timestamp.timestampToDateTime().endOfMonth();
    final startOfTheMonthOfLastAnalysisModelTimestamp =
        lastAnalysisModelTimestamp.startOfMonth();
    List<DateTime> startOfWeekList = <DateTime>[
      for (DateTime dateIndex = lastAnalysisModelTimestamp;
          dateIndex.isAfter(startOfTheMonthOfLastAnalysisModelTimestamp);
          dateIndex = dateIndex.subtract(const Duration(days: 1)))
        dateIndex
    ];
    return startOfWeekList.toSet();
  }

  String chartTitle(List<DateTime> week) {
    final currentWeekIndex = weekDates.indexOf(week);
    return switch (currentWeekIndex) {
      0 => 'This week',
      1 => 'Last week',
      2 => '2 weeks ago',
      3 => '3 weeks ago',
      4 => '4 weeks ago',
      5 => '5 weeks ago',
      _ => '6 weeks ago',
    };
  }
}
