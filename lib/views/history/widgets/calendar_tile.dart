import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../../extensions/number_extensions.dart';
import '../../../models/analysis/analysis_model.dart';
import '../../../models/note/note_model.dart';
import '../../../providers/settings_providers.dart';
import '../../../services/firestore_service.dart';
import '../../../utils/constants.dart';
import '../../../utils/helper_functions.dart';
import '../../../utils/show_healpen_dialog.dart';
import '../../../widgets/custom_dialog.dart';
import '../../../widgets/custom_list_tile.dart';
import 'note_tile.dart';

class CalendarTile extends ConsumerWidget {
  final List<NoteModel> noteModels;

  const CalendarTile({super.key, required this.noteModels});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SfCalendar(
      showCurrentTimeIndicator: false,
      showTodayButton: true,
      showWeekNumber: false,
      allowViewNavigation: false,
      showNavigationArrow: false,
      showDatePickerButton: false,
      view: CalendarView.month,
      maxDate: DateTime.now(),
      viewNavigationMode: ViewNavigationMode.snap,
      headerStyle: CalendarHeaderStyle(
        textStyle: context.theme.textTheme.titleLarge!.copyWith(
          color: context.theme.colorScheme.onSurface,
        ),
      ),
      onTap: (CalendarTapDetails details) {
        if (details.appointments!.isNotEmpty) {
          showHealpenDialog(
            context: context,
            doVibrate: ref.watch(navigationEnableHapticFeedbackProvider),
            customDialog: CustomDialog(
              titleString: DateFormat('EEE d MMM yyyy').format(details.date!),
              enableContentContainer: false,
              contentWidget: Padding(
                padding: EdgeInsets.all(gap),
                child: details.appointments!.isNotEmpty
                    ? SizedBox(
                        height: 42.h,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(radius - gap),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ...details.appointments!.map(
                                  (element) => Padding(
                                    padding: EdgeInsets.only(bottom: gap),
                                    child: NoteTile(
                                      entry: noteModels.where(
                                        (NoteModel element) {
                                          return element.timestamp ==
                                              int.parse(details
                                                  .appointments!.first.subject);
                                        },
                                      ).first,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                    : CustomListTile(
                        responsiveWidth: true,
                        titleString: 'No notes',
                        cornerRadius: radius - gap,
                        backgroundColor: context.theme.colorScheme.surface,
                        textColor: context.theme.colorScheme.onSurface,
                      ),
              ),
              actions: [
                CustomListTile(
                  responsiveWidth: true,
                  titleString: 'Close',
                  cornerRadius: radius - gap,
                  onTap: () {
                    context.navigator.pop();
                  },
                )
              ],
            ),
          );
        }
      },
      dataSource: DataSource(
        <Appointment>[
          for (NoteModel noteModel in noteModels) ...[
            Appointment(
              startTime:
                  DateTime.fromMillisecondsSinceEpoch(noteModel.timestamp),
              endTime: DateTime.fromMillisecondsSinceEpoch(noteModel.timestamp),
              isAllDay: true,
              color: context.theme.colorScheme.secondary,
              subject: noteModel.timestamp.toString(),
            ),
          ]
        ],
      ),
      initialSelectedDate: DateTime.now(),
      firstDayOfWeek: 1,
      todayHighlightColor: context.theme.colorScheme.secondary,
      cellBorderColor: context.theme.colorScheme.surface,
      selectionDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(
          color: context.theme.colorScheme.primary,
          width: gap / 4,
        ),
      ),
      monthViewSettings: const MonthViewSettings(
        showAgenda: false,
        dayFormat: 'EEE',
        appointmentDisplayMode: MonthAppointmentDisplayMode.none,
        showTrailingAndLeadingDates: false,
      ),
      monthCellBuilder: (BuildContext context, MonthCellDetails details) {
        // print details.date in yyyy-mm-dd format
        bool todayCheck = DateFormat('yyyy-MM-dd').format(details.date) ==
            DateFormat('yyyy-MM-dd').format(DateTime.now());
        bool currentMonthCheck =
            details.date.month == details.visibleDates[15].month;
        bool dateAfterTodayCheck = details.date.isAfter(DateTime.now());
        Color? shapeColor;
        Color? textColor;
        if (details.appointments.isNotEmpty) {
          List<NoteModel> dateNoteModels = [
            ...details.appointments.map((Object e) => noteModels.where(
                  (element) {
                    return element.timestamp ==
                        int.parse((e as Appointment).subject);
                  },
                ).first),
          ];
          List<AnalysisModel> dateAnalysisModels = [];
          getDateAnalysisModels(dateNoteModels).then((value) {
            dateAnalysisModels = value;
          });

          double sentimentRatio = getSentimentRatio(
            [
              for (AnalysisModel element in dateAnalysisModels)
                element.sentiment!,
            ].average().toDouble(),
          );
          log(dateAnalysisModels.toString(), name: 'dateAnalysisModels');
          log(sentimentRatio.toString(), name: 'sentimentRatio');
          // shapeColor = getSentimentShapeColor(sentimentRatio);
          // textColor = getSentimentTexColor(sentimentRatio);
        }
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                top: gap,
                left: gap,
                right: gap,
              ),
              child: Container(
                alignment: Alignment.center,
                height: gap * 4,
                width: gap * 4,
                decoration: todayCheck
                    ? BoxDecoration(
                        borderRadius: BorderRadius.circular(radius - gap),
                        color: context.theme.colorScheme.secondary,
                      )
                    : !dateAfterTodayCheck
                        ? BoxDecoration(
                            borderRadius: BorderRadius.circular(radius - gap),
                            color: context.theme.colorScheme.secondaryContainer,
                          )
                        : null,
                child: Text(
                  details.date.day.toString(),
                  style: context.theme.textTheme.titleLarge!.copyWith(
                    color: todayCheck
                        ? context.theme.colorScheme.onSecondary
                        : currentMonthCheck && !dateAfterTodayCheck
                            ? context.theme.colorScheme.onSecondaryContainer
                            : context.theme.colorScheme.outlineVariant,
                    fontWeight: currentMonthCheck && !dateAfterTodayCheck
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ),
            ),
            const Spacer(),
            if (details.appointments.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(bottom: gap),
                child: ClipOval(
                  child: Container(
                    height: gap * 3,
                    width: gap * 3,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: shapeColor,
                    ),
                    child: Text(
                      details.appointments.length.toString(),
                      textAlign: TextAlign.center,
                      style: context.theme.textTheme.titleMedium!.copyWith(
                        color: textColor,
                        fontWeight: FontWeight.bold,
                        textBaseline: TextBaseline.alphabetic,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Future<List<AnalysisModel>> getDateAnalysisModels(
      List<NoteModel> dateNoteModels) async {
    List<Future<AnalysisModel>> futures = dateNoteModels.map(
      (NoteModel noteModel) async {
        var data = await FirestoreService.getAnalysis(noteModel.timestamp);
        return AnalysisModel.fromJson(data.data()!);
      },
    ).toList();

    List<AnalysisModel> dateAnalysisModels = await Future.wait(futures);
    return dateAnalysisModels;
  }
}

class DataSource extends CalendarDataSource {
  DataSource(List source) {
    appointments = source;
  }
}
