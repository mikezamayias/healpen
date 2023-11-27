import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../../controllers/analysis_view_controller.dart';
import '../../../../../extensions/date_time_extensions.dart';
import '../../../../../extensions/int_extensions.dart';
import '../../../../../models/analysis/analysis_model.dart';
import '../../../../../providers/settings_providers.dart';
import '../../../../../utils/constants.dart';
import '../../../../../widgets/text_divider.dart';
import 'widgets/week_line_chart.dart';

/// A tile widget that displays the journaling rhythm.
///
/// This widget is used to display a column of week-based line charts,
/// representing the journaling rhythm over time. Each chart represents a week,
/// with the most recent week at the top. The charts are generated based on the
/// provided [analysisModelList], which contains the analysis data for each
/// journal entry. The [weekDates] list is initialized using the
/// [initializeWeekDates] method, which calculates the start and end dates for
/// each week based on the analysis data. The [chartTitle] method generates the
/// title for each chart based on the week's position relative to the current
/// date.
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

  /// Initializes the list of week dates based on the provided
  /// [analysisModelList].
  ///
  /// This method calculates the start and end dates for each week based on the
  /// analysis data in [analysisModelList]. It first extracts the months from
  /// the analysis data, then groups the dates into weeks. The resulting list
  /// of week dates is filtered to remove weeks that do not have any analysis
  /// data. Finally, the start and end dates of each week are logged for
  /// debugging purposes.
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
    weekList.removeWhere(
      (week) => !analysisModelList.any(
        (note) =>
            note.timestamp.timestampToDateTime().isAfter(week.first) &&
            note.timestamp.timestampToDateTime().isBefore(week.last),
      ),
    );
    return weekList;
  }

  /// Extracts the months from the provided [analysisModelList].
  ///
  /// This method takes the analysis data in [analysisModelList] and extracts
  /// the months from the timestamps. It starts from the current date and goes
  /// backwards until the timestamp of the first analysis model in the list.
  /// The resulting list of start of week dates is reversed and converted to a
  /// set to remove duplicates.
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

  /// Generates the title for the chart based on the provided [week].
  ///
  /// This method calculates the number of weeks between the last week in the
  /// [weekDates] list and the current date. It returns a string representing
  /// the title of the chart based on the number of weeks. If the number of
  /// weeks is 0, it returns 'This week'. If it is 1, it returns 'Last week'.
  /// Otherwise, it returns '$delta weeks ago', where delta is the number of
  /// weeks.
  String chartTitle(List<DateTime> week) {
    final delta = week.last.weeksBefore(DateTime.now());
    return switch (delta) {
      0 => 'This week',
      1 => 'Last week',
      _ => '$delta weeks ago',
    };
  }
}
