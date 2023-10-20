import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../../../controllers/history_view_controller.dart';
import '../../../../extensions/int_extensions.dart';
import '../../../../models/analysis/analysis_model.dart';
import '../../../../models/note/note_model.dart';
import '../../../../providers/settings_providers.dart';
import '../../../../services/note_analysis_service.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/helper_functions.dart';
import '../../../../utils/show_healpen_dialog.dart';
import '../../../../widgets/custom_dialog.dart';
import '../../../../widgets/custom_list_tile.dart';
import 'widgets/date_dialog.dart';

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
      showTodayButton: false,
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
        borderRadius: BorderRadius.circular(radius - gap / 2),
        border: Border.all(
          color: context.theme.colorScheme.primary,
          width: gap / 3,
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
    final smallNavigationElements =
        ref.watch(navigationSmallerNavigationElementsProvider);
    return StreamBuilder(
      stream: NoteAnalysisService().getAnalysisEntriesListOnDate(details.date),
      builder: (
        BuildContext context,
        AsyncSnapshot<List<AnalysisModel>> analysisModelListSnapshot,
      ) {
        Color shapeColor = context.theme.colorScheme.surface;
        Color textColor = context.theme.colorScheme.onSurface;
        double? dateSentiment;
        if (analysisModelListSnapshot.data != null &&
            analysisModelListSnapshot.data!.isNotEmpty) {
          List<AnalysisModel> analysisModelList =
              analysisModelListSnapshot.data!;
          if (analysisModelList.isNotEmpty) {
            dateSentiment = [
              for (AnalysisModel element in analysisModelList)
                element.sentiment!,
            ].average;
            shapeColor = Color.lerp(
              context.theme.colorScheme.error,
              context.theme.colorScheme.primary,
              getSentimentRatio(dateSentiment),
            )!;
            textColor = Color.lerp(
              context.theme.colorScheme.onError,
              context.theme.colorScheme.onPrimary,
              getSentimentRatio(dateSentiment),
            )!;
          }
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
                if (smallNavigationElements) Gap(gap),
                AnimatedContainer(
                  duration: standardDuration,
                  curve: standardCurve,
                  alignment: Alignment.center,
                  child: Text(
                    details.date.day.toString(),
                    style: context.theme.textTheme.titleMedium!.copyWith(
                      color: currentMonthCheck &&
                              !dateAfterTodayCheck &&
                              !dateBeforeFirstRecordCheck
                          ? textColor
                          : context.theme.colorScheme.outlineVariant,
                      fontWeight: currentMonthCheck &&
                              !dateAfterTodayCheck &&
                              !dateBeforeFirstRecordCheck &&
                              todayCheck
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ),
                if (smallNavigationElements) Gap(gap),
                Expanded(
                  child: Visibility(
                    visible: details.appointments.isNotEmpty,
                    child: Center(
                      child: StreamBuilder(
                        stream: NoteAnalysisService()
                            .getNoteEntriesListOnDate(details.date),
                        builder:
                            (context, AsyncSnapshot<List<NoteModel>> snapshot) {
                          if (snapshot.hasData) {
                            return Text(
                              '${snapshot.data!.length}',
                              textAlign: TextAlign.center,
                              style:
                                  context.theme.textTheme.titleSmall!.copyWith(
                                color: textColor,
                                fontWeight: FontWeight.bold,
                                textBaseline: TextBaseline.alphabetic,
                              ),
                            ).animate().fade(
                                  duration: standardDuration,
                                  curve: standardCurve,
                                );
                          } else {
                            return const SizedBox();
                          }
                        },
                      ),
                    ),
                  ),
                ),
                if (smallNavigationElements) Gap(gap),
              ],
            ),
          ),
        );
      },
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
        contentWidget: DateDialog(date: details.date!),
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

class DataSource extends CalendarDataSource {
  DataSource(List<Appointment> source) {
    appointments = source;
  }

  void updateAppointments(List<Appointment> newAppointments) {
    appointments = newAppointments;
    notifyListeners(CalendarDataSourceAction.reset, newAppointments);
  }
}
