import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../../controllers/history_view_controller.dart';
import '../../../extensions/int_extensions.dart';
import '../../../models/analysis/analysis_model.dart';
import '../../../models/note/note_model.dart';
import '../../../providers/settings_providers.dart';
import '../../../utils/constants.dart';
import '../../../utils/helper_functions.dart';
import '../../../utils/show_healpen_dialog.dart';
import '../../../widgets/custom_dialog.dart';
import '../../../widgets/custom_list_tile.dart';
import 'note_tile.dart';

class CalendarTile extends ConsumerStatefulWidget {
  final List<NoteModel> noteModels;

  const CalendarTile({Key? key, required this.noteModels}) : super(key: key);

  @override
  ConsumerState<CalendarTile> createState() => _CalendarTileState();
}

class _CalendarTileState extends ConsumerState<CalendarTile> {
  @override
  Widget build(BuildContext context) {
    return SfCalendar(
      showCurrentTimeIndicator: false,
      showTodayButton: true,
      showWeekNumber: false,
      allowViewNavigation: false,
      showNavigationArrow: false,
      showDatePickerButton: false,
      view: CalendarView.month,
      maxDate: DateTime.now(),
      minDate:
          HistoryViewController.noteModels.last.timestamp.timestampToDateTime(),
      viewNavigationMode: ViewNavigationMode.snap,
      headerStyle: CalendarHeaderStyle(
        textStyle: context.theme.textTheme.titleLarge!.copyWith(
          color: context.theme.colorScheme.onSurface,
        ),
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
      dataSource: DataSource(_createAppointments(widget.noteModels, context)),
      onTap: _onTap,
      monthCellBuilder: _monthlyBuilder,
    );
  }

  Widget _monthlyBuilder(
    BuildContext context,
    MonthCellDetails details,
  ) {
    bool todayCheck = DateFormat('yyyy-MM-dd').format(details.date) ==
        DateFormat('yyyy-MM-dd').format(DateTime.now());
    bool currentMonthCheck =
        details.date.month == details.visibleDates[15].month;
    bool dateAfterTodayCheck = details.date.isAfter(DateTime.now());
    bool dateBeforeFirstRecordCheck = details.date.isBefore(
      HistoryViewController.noteModels.last.timestamp
          .timestampToDateTime()
          .subtract(1.days),
    );
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(
            top: gap,
            left: gap,
            right: gap,
          ),
          child: AnimatedContainer(
            duration: standardDuration,
            curve: standardCurve,
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
                    : currentMonthCheck &&
                            !dateAfterTodayCheck &&
                            !dateBeforeFirstRecordCheck
                        ? context.theme.colorScheme.onSecondaryContainer
                        : context.theme.colorScheme.outlineVariant,
                fontWeight: currentMonthCheck &&
                        !dateAfterTodayCheck &&
                        !dateBeforeFirstRecordCheck
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
          ),
        ),
        const Spacer(),
        Padding(
          padding: EdgeInsets.only(bottom: gap),
          child: ClipOval(
            child: StreamBuilder(
                stream: NoteAnalysisService()
                    .getAnalysisEntriesListOnDate(details.date),
                builder: (
                  BuildContext context,
                  AsyncSnapshot<List<AnalysisModel>> analysisModelListSnapshot,
                ) {
                  Color? shapeColor;
                  Color? textColor;
                  double? dateSentiment;
                  double? dateSentimentRatio;
                  if (analysisModelListSnapshot.data != null &&
                      analysisModelListSnapshot.data!.isNotEmpty) {
                    log(
                      '${analysisModelListSnapshot.data}',
                      name: 'analysisModelListSnapshot',
                    );
                    List<AnalysisModel> analysisModelList =
                        analysisModelListSnapshot.data!;
                    if (analysisModelList.isNotEmpty) {
                      dateSentiment = [
                        for (AnalysisModel element in analysisModelList)
                          element.sentiment!,
                      ].average;
                      dateSentimentRatio = getSentimentRatio(dateSentiment);
                      shapeColor = getSentimentShapeColor(dateSentimentRatio);
                      textColor = getSentimentTexColor(dateSentimentRatio);
                    }
                  }
                  return AnimatedContainer(
                    duration: standardDuration,
                    curve: standardCurve,
                    // height: shapeColor == null ? 0 : gap * 3,
                    // width: shapeColor == null ? 0 : gap * 3,
                    height: details.appointments.isNotEmpty ? gap * 3 : 0,
                    width: details.appointments.isNotEmpty ? gap * 3 : 0,
                    alignment: Alignment.center,
                    decoration: details.appointments.isNotEmpty
                        ? BoxDecoration(
                            color: shapeColor ?? theme.colorScheme.primary)
                        : null,
                    // : BoxDecoration(color: shapeColor),
                    child: Text(
                      '${details.appointments.length}',
                      textAlign: TextAlign.center,
                      style: context.theme.textTheme.titleMedium!.copyWith(
                        color: textColor ?? theme.colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                        textBaseline: TextBaseline.alphabetic,
                      ),
                    ),
                  );
                }),
          ),
        )
      ],
    );
  }

  // Utility method to create Appointments
  List<Appointment> _createAppointments(
    List<NoteModel> noteModels,
    BuildContext context,
  ) {
    return noteModels.map((noteModel) {
      return Appointment(
        startTime: DateTime.fromMillisecondsSinceEpoch(noteModel.timestamp),
        endTime: DateTime.fromMillisecondsSinceEpoch(noteModel.timestamp),
        isAllDay: true,
        color: context.theme.colorScheme.secondary,
        subject: noteModel.timestamp.toString(),
      );
    }).toList();
  }

  // Utility method to handle onTap
  void _onTap(CalendarTapDetails details) {
    if (details.appointments != null && details.appointments!.isNotEmpty) {
      _showCustomDialog(details, context, ref);
    }
  }

  // Utility method to show Custom Dialog
  void _showCustomDialog(
    CalendarTapDetails details,
    BuildContext context,
    WidgetRef ref,
  ) {
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
                    child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: HistoryViewController()
                          .getNoteEntriesListOnDate(details.date!)
                          .snapshots(includeMetadataChanges: true),
                      builder: (
                        BuildContext context,
                        AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                            querySnapshot,
                      ) {
                        if (querySnapshot.connectionState ==
                            ConnectionState.active) {
                          List<NoteTile> widgets = [
                            ...querySnapshot.data!.docs.map(
                              (e) => NoteTile(
                                entry: NoteModel.fromJson(e.data()),
                              ),
                            )
                          ];
                          return ListView.separated(
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) =>
                                widgets[index],
                            separatorBuilder: (_, __) => SizedBox(height: gap),
                            itemCount: widgets.length,
                          );
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
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
              Navigator.pop(navigatorKey.currentContext!);
            },
          )
        ],
      ),
    );
  }
}

class NoteAnalysisService {
  Stream<List<NoteModel>> getNoteEntriesListOnDate(DateTime date) {
    return HistoryViewController()
        .getNoteEntriesListOnDate(date)
        .snapshots(includeMetadataChanges: true)
        .map(
          (QuerySnapshot<Map<String, dynamic>> query) => [
            ...query.docs.map(
              (e) => NoteModel.fromJson(e.data()),
            )
          ],
        );
  }

  Stream<List<AnalysisModel>> getAnalysisEntriesListOnDate(DateTime date) {
    return HistoryViewController()
        .getNoteEntriesListOnDate(date)
        .snapshots(includeMetadataChanges: true)
        .map(
      (QuerySnapshot<Map<String, dynamic>> query) {
        return [
          ...query.docs.map(
            (QueryDocumentSnapshot<Map<String, dynamic>> e) =>
                AnalysisModel.fromJson(e.data()),
          )
        ];
      },
    );
  }
}

class DataSource extends CalendarDataSource {
  DataSource(List<Appointment> source) {
    appointments = source;
  }

  void updateAppointments(List<Appointment> newAppointments) {
    appointments = newAppointments;
    notifyListeners(CalendarDataSourceAction.reset, newAppointments);
  }
}
