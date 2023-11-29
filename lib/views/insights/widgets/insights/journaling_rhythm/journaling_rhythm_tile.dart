import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../../controllers/analysis_view_controller.dart';
import '../../../../../extensions/analysis_model_extensions.dart';
import '../../../../../extensions/date_time_extensions.dart';
import '../../../../../providers/settings_providers.dart';
import '../../../../../utils/constants.dart';
import '../../../../../widgets/text_divider.dart';
import 'widgets/week_line_chart.dart';

class JournalingRhythmTile extends ConsumerWidget {
  const JournalingRhythmTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analysisModelList = ref.watch(analysisModelListProvider);
    Set<DateTime> weekSet = analysisModelList.getWeeksFromAnalysisModelList();
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
                height: 27.h,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: gap),
                      child: TextDivider(week.lineChartTitle()),
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
