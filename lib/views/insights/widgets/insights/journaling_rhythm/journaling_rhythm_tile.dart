import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../../controllers/analysis_view_controller.dart';
import '../../../../../extensions/int_extensions.dart';
import '../../../../../models/analysis/analysis_model.dart';
import '../../../../../providers/settings_providers.dart';
import '../../../../../utils/constants.dart';
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
    return Padding(
      padding: ref.watch(navigationSmallerNavigationElementsProvider)
          ? EdgeInsets.zero
          : EdgeInsets.all(gap),
      child: SingleChildScrollView(
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
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: gap),
                      child: TextDivider(chartTitle(week)),
                    ),
                    Expanded(
                      child: WeekLineChart(week),
                    )
                  ],
                ),
              );
            },
          ).toList(),
        ),
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
    final start = DateTime.parse(
      DateFormat('yyyy-MM-dd').format(DateTime.now().add(1.days)),
    ).millisecondsSinceEpoch.timestampToDateTime();
    final lastAnalysisDateTime = DateTime.parse(
      DateFormat('yyyy-MM-dd').format(
        analysisModelList.first.timestamp.timestampToDateTime(),
      ),
    );
    List<DateTime> startOfWeekList = <DateTime>[];
    for (DateTime date = lastAnalysisDateTime;
        date.millisecondsSinceEpoch <= start.millisecondsSinceEpoch;
        date = date.add(const Duration(days: 1))) {
      startOfWeekList.add(
        DateTime.parse(DateFormat('yyyy-MM-dd').format(date)),
      );
    }
    return startOfWeekList.reversed.toSet();
  }

  String chartTitle(List<DateTime> week) {
    final currentWeekIndex = weekDates.indexOf(week);
    return switch (currentWeekIndex) {
      0 => 'This week',
      1 => 'Last week',
      _ => '$currentWeekIndex weeks ago',
    };
  }
}
