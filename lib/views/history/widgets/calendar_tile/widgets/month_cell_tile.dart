import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../../../../controllers/history_view_controller.dart';
import '../../../../../extensions/int_extensions.dart';
import '../../../../../providers/settings_providers.dart';

class MonthCellTile extends ConsumerWidget {
  final MonthCellDetails cellDetails;
  const MonthCellTile({super.key, required this.cellDetails});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool todayCheck = DateFormat('yyyy-MM-dd').format(cellDetails.date) ==
        DateFormat('yyyy-MM-dd').format(DateTime.now());
    bool currentMonthCheck =
        cellDetails.date.month == cellDetails.visibleDates[15].month;
    bool dateAfterTodayCheck = cellDetails.date.isAfter(DateTime.now());
    bool dateBeforeFirstRecordCheck = cellDetails.date.isBefore(
      HistoryViewController.noteModels.last.timestamp
          .timestampToDateTime()
          .subtract(1.days),
    );
    final smallNavigationElements =
        ref.watch(navigationSmallerNavigationElementsProvider);
    // return StreamBuilder(
    //   stream:
    //       NoteAnalysisService().getAnalysisEntriesListOnDate(cellDetails.date),
    //   builder: (
    //     BuildContext context,
    //     AsyncSnapshot<List<AnalysisModel>> analysisModelListSnapshot,
    //   ) {
    //     Color shapeColor = smallNavigationElements
    //         ? context.theme.colorScheme.surfaceVariant
    //         : context.theme.colorScheme.surface;
    //     Color textColor = smallNavigationElements
    //         ? context.theme.colorScheme.onSurfaceVariant
    //         : context.theme.colorScheme.onSurface;
    //     double? dateSentiment;
    //     if (analysisModelListSnapshot.data != null &&
    //         analysisModelListSnapshot.data!.isNotEmpty) {
    //       List<AnalysisModel> analysisModelList =
    //           analysisModelListSnapshot.data!;
    //       if (analysisModelList.isNotEmpty) {
    //         dateSentiment = [
    //           for (AnalysisModel element in analysisModelList) element.score,
    //         ].average;
    //         shapeColor = getShapeColorOnSentiment(context.theme, dateSentiment);
    //         textColor = getTextColorOnSentiment(context.theme, dateSentiment);
    //       }
    //     }
    //     int noteCount = 0;
    //     final DateTime cellDate = cellDetails.date;
    //     for (NoteModel note in HistoryViewController.notesToAnalyze) {
    //       DateTime noteDate =
    //           DateTime.fromMillisecondsSinceEpoch(note.timestamp);
    //       if (noteDate.year == cellDate.year &&
    //           noteDate.month == cellDate.month &&
    //           noteDate.day == cellDate.day) {
    //         noteCount++;
    //       }
    //     }
    //     return Padding(
    //       padding: EdgeInsets.all(gap / 2),
    //       child: AnimatedContainer(
    //         duration: standardDuration,
    //         curve: standardCurve,
    //         decoration: BoxDecoration(
    //           borderRadius: BorderRadius.circular(radius - gap),
    //           color: shapeColor,
    //         ),
    //         child: Column(
    //           mainAxisAlignment: MainAxisAlignment.start,
    //           children: <Widget>[
    //             Gap(gap / 2),
    //             AnimatedContainer(
    //               duration: standardDuration,
    //               curve: standardCurve,
    //               alignment: Alignment.center,
    //               child: Text(
    //                 cellDetails.date.day.toString(),
    //                 style: context.theme.textTheme.titleMedium!.copyWith(
    //                   color: currentMonthCheck &&
    //                           !dateAfterTodayCheck &&
    //                           !dateBeforeFirstRecordCheck
    //                       ? textColor
    //                       : textColor.withOpacity(0.5),
    //                   fontWeight: currentMonthCheck &&
    //                           !dateAfterTodayCheck &&
    //                           !dateBeforeFirstRecordCheck &&
    //                           todayCheck
    //                       ? FontWeight.bold
    //                       : FontWeight.normal,
    //                 ),
    //               ),
    //             ),
    //             const Spacer(),
    //             if (noteCount != 0)
    //               Center(
    //                 child: ClipOval(
    //                   child: Container(
    //                     color: textColor,
    //                     width: context.theme.textTheme.headlineSmall!.fontSize!,
    //                     height:
    //                         context.theme.textTheme.headlineSmall!.fontSize!,
    //                     alignment: Alignment.center,
    //                     child: Text(
    //                       '$noteCount',
    //                       textAlign: TextAlign.center,
    //                       style: context.theme.textTheme.titleSmall!.copyWith(
    //                         color: shapeColor,
    //                         fontWeight: FontWeight.bold,
    //                         textBaseline: TextBaseline.alphabetic,
    //                       ),
    //                     ).animate().fade(
    //                           duration: standardDuration,
    //                           curve: standardCurve,
    //                         ),
    //                   ),
    //                 ),
    //               ),
    //             Gap(gap),
    //           ],
    //         ),
    //       ),
    //     );
    //   },
    // );
    return Text(
      cellDetails.date.day.toString(),
      style: context.theme.textTheme.titleMedium!.copyWith(
        fontWeight: currentMonthCheck &&
                !dateAfterTodayCheck &&
                !dateBeforeFirstRecordCheck &&
                todayCheck
            ? FontWeight.bold
            : FontWeight.normal,
      ),
    );
  }
}
