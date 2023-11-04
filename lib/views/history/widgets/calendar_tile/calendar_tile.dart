import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../../../controllers/history_view_controller.dart';
import '../../../../extensions/int_extensions.dart';
import '../../../../models/note/note_model.dart';
import '../../../../providers/settings_providers.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/show_healpen_dialog.dart';
import '../../../../widgets/custom_dialog.dart';
import '../../../../widgets/custom_list_tile.dart';
import 'widgets/date_dialog.dart';
import 'widgets/month_cell_tile.dart';

class CalendarTile extends ConsumerStatefulWidget {
  final List<NoteModel> noteModels;

  const CalendarTile({super.key, required this.noteModels});

  @override
  ConsumerState<CalendarTile> createState() => _CalendarTileState();
}

class _CalendarTileState extends ConsumerState<CalendarTile> {
  @override
  Widget build(BuildContext context) {
    final smallNavigationElements =
        ref.watch(navigationSmallerNavigationElementsProvider);
    return Padding(
      padding:
          smallNavigationElements ? EdgeInsets.all(gap / 2) : EdgeInsets.zero,
      child: SfCalendar(
        showCurrentTimeIndicator: false,
        showTodayButton: false,
        showWeekNumber: false,
        allowViewNavigation: false,
        showNavigationArrow: false,
        showDatePickerButton: false,
        view: CalendarView.month,
        maxDate: DateTime.now(),
        minDate: HistoryViewController.noteModels.last.timestamp
            .timestampToDateTime(),
        viewNavigationMode: ViewNavigationMode.snap,
        headerStyle: CalendarHeaderStyle(
          textStyle: context.theme.textTheme.titleLarge!.copyWith(
            color: smallNavigationElements
                ? context.theme.colorScheme.onSurfaceVariant
                : context.theme.colorScheme.onSurface,
          ),
        ),
        initialSelectedDate: DateTime.now(),
        firstDayOfWeek: 1,
        todayHighlightColor: context.theme.colorScheme.secondary,
        cellBorderColor: context.theme.colorScheme.surface,
        selectionDecoration: const BoxDecoration(),
        monthViewSettings: const MonthViewSettings(
          showAgenda: false,
          dayFormat: 'EEE',
          appointmentDisplayMode: MonthAppointmentDisplayMode.none,
          showTrailingAndLeadingDates: false,
        ),
        dataSource: DataSource(_createAppointments(widget.noteModels, context)),
        onTap: _onTap,
        monthCellBuilder: _monthlyBuilder,
      ),
    );
  }

  Widget _monthlyBuilder(BuildContext context, MonthCellDetails details) =>
      MonthCellTile(cellDetails: details);

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
            useSmallerNavigationSetting: false,
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
