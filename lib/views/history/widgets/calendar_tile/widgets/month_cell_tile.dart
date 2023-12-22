import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../../../../controllers/analysis_view_controller.dart';
import '../../../../../extensions/analysis_model_extensions.dart';
import '../../../../../extensions/date_time_extensions.dart';
import '../../../../../extensions/int_extensions.dart';
import '../../../../../models/analysis/analysis_model.dart';
import '../../../../../providers/settings_providers.dart';
import '../../../../../utils/constants.dart';
import '../../../../../utils/helper_functions.dart';

class MonthCellTile extends ConsumerWidget {
  final MonthCellDetails cellDetails;

  const MonthCellTile({
    super.key,
    required this.cellDetails,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final smallNavigationElements =
        ref.watch(navigationSmallerNavigationElementsProvider);
    Color shapeColor = smallNavigationElements
        ? context.theme.colorScheme.surfaceVariant
        : context.theme.colorScheme.surface;
    Color textColor = smallNavigationElements
        ? context.theme.colorScheme.onSurfaceVariant
        : context.theme.colorScheme.onSurface;
    final DateTime cellDate = cellDetails.date;
    final dateAnalysisModelList =
        ref.watch(analysisModelSetProvider).getAnalysisBetweenDates(
              start: cellDate.startOfDay(),
              end: cellDate.endOfDay(),
            );
    bool todayCheck = DateFormat('yyyy-MM-dd').format(cellDate) ==
        DateFormat('yyyy-MM-dd').format(DateTime.now());
    bool currentMonthCheck =
        cellDate.month == cellDetails.visibleDates[15].month;
    bool dateAfterTodayCheck = cellDate.isAfter(DateTime.now());
    bool dateBeforeFirstRecordCheck = cellDate.isBefore(
      ref
          .watch(analysisModelSetProvider)
          .first
          .timestamp
          .timestampToDateTime()
          .subtract(1.days),
    );
    double? dateSentiment;
    if (dateAnalysisModelList.isNotEmpty) {
      dateSentiment = dateAnalysisModelList
          .map((AnalysisModel element) => element.score)
          .average;
      shapeColor = getShapeColorOnSentiment(context.theme, dateSentiment);
      textColor = getTextColorOnSentiment(context.theme, dateSentiment);
    }
    return Padding(
      padding: EdgeInsets.all(gap / 2),
      child: AnimatedContainer(
        duration: standardDuration,
        curve: standardCurve,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius - gap),
          color: shapeColor,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            AnimatedContainer(
              duration: standardDuration,
              curve: standardCurve,
              alignment: Alignment.center,
              padding: EdgeInsets.only(top: gap / 2),
              child: Text(
                cellDate.day.toString(),
                style: context.theme.textTheme.titleMedium!.copyWith(
                  color: currentMonthCheck &&
                          !dateAfterTodayCheck &&
                          !dateBeforeFirstRecordCheck
                      ? textColor
                      : textColor.withOpacity(0.5),
                  fontWeight: currentMonthCheck &&
                          !dateAfterTodayCheck &&
                          !dateBeforeFirstRecordCheck &&
                          todayCheck
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
            ),
            if (dateAnalysisModelList.isNotEmpty)
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(bottom: gap / 2),
                child: ClipOval(
                  child: Container(
                    color: textColor,
                    width: context.theme.textTheme.headlineSmall!.fontSize!,
                    height: context.theme.textTheme.headlineSmall!.fontSize!,
                    alignment: Alignment.center,
                    child: Text(
                      '${dateAnalysisModelList.length}',
                      textAlign: TextAlign.center,
                      style: context.theme.textTheme.titleSmall!.copyWith(
                        color: shapeColor,
                        fontWeight: FontWeight.bold,
                        textBaseline: TextBaseline.alphabetic,
                      ),
                    ).animate().fade(
                          duration: standardDuration,
                          curve: standardCurve,
                        ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
