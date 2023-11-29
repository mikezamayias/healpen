import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../../controllers/analysis_view_controller.dart';
import '../../../../../extensions/date_time_extensions.dart';
import '../../../../../extensions/int_extensions.dart';
import '../../../../../providers/settings_providers.dart';
import '../../../../../utils/constants.dart';
import '../../../../../widgets/text_divider.dart';
import 'widgets/week_line_chart.dart';

class JournalingRhythmTile extends ConsumerWidget {
  const JournalingRhythmTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analysisModelList = ref.watch(analysisModelListProvider);

    // log the first and last entries in the analysisModelList
    log(
      DateFormat('yyyy-MM-dd')
          .format(analysisModelList.first.timestamp.timestampToDateTime()),
      name: 'JournalingRhythmTile:build:firstEntry',
    );
    log(
      DateFormat('yyyy-MM-dd')
          .format(analysisModelList.last.timestamp.timestampToDateTime()),
      name: 'JournalingRhythmTile:build:lastEntry',
    );
    // starting from the last entry, generate a list of weeks until the first
    // entry
    var weekSet = <DateTime>[
      for (DateTime date =
              analysisModelList.last.timestamp.timestampToDateTime();
          date.isAfter(analysisModelList.first.timestamp.timestampToDateTime());
          date = date.subtract(const Duration(days: 7)))
        // check if there are any entries in the analysisModelList that are in the
        // current week. If there are, add the current week to the list of weeks
        if (analysisModelList.any(
          (note) =>
              note.timestamp
                  .timestampToDateTime()
                  .isAfter(date.subtract(7.days)) &&
              note.timestamp.timestampToDateTime().isBefore(date),
        ))
          date
    ].sorted((a, b) => a.compareTo(b)).toSet();
    // log the list of weeks
    log(
      weekSet.map((e) => DateFormat('yyyy-MM-dd').format(e)).join(', '),
      name: 'JournalingRhythmTile:build:weekList',
    );

    return Padding(
      padding: ref.watch(navigationSmallerNavigationElementsProvider)
          ? EdgeInsets.zero
          : EdgeInsets.all(gap),
      child: SingleChildScrollView(
        reverse: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: weekSet.map<Widget>(
            (DateTime week) {
              return SizedBox(
                height: 36.h,
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
}
