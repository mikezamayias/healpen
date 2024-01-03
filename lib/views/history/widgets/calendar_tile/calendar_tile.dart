import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../../../controllers/analysis_view_controller.dart';
import '../../../../extensions/int_extensions.dart';
import '../../../../models/analysis/analysis_model.dart';
import '../../../../providers/settings_providers.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/show_healpen_dialog.dart';
import 'widgets/date_dialog.dart';
import 'widgets/month_cell_tile.dart';

class CalendarTile extends ConsumerStatefulWidget {
  const CalendarTile({super.key});

  @override
  ConsumerState<CalendarTile> createState() => _CalendarTileState();
}

class _CalendarTileState extends ConsumerState<CalendarTile> {
  @override
  Widget build(BuildContext context) {
    final useSmallerNavigationElements =
        ref.watch(navigationSmallerNavigationElementsProvider);
    final analysisModelList = ref.watch(analysisModelSetProvider);
    final maxDate = DateTime.now();
    final minDate = analysisModelList.first.timestamp.timestampToDateTime();
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(radius),
      ),
      padding: EdgeInsets.all(gap / 2),
      child: SfCalendar(
        showCurrentTimeIndicator: false,
        showTodayButton: false,
        showWeekNumber: false,
        allowViewNavigation: false,
        showNavigationArrow: false,
        showDatePickerButton: false,
        view: CalendarView.month,
        maxDate: maxDate,
        minDate: minDate,
        viewNavigationMode: ViewNavigationMode.snap,
        headerStyle: CalendarHeaderStyle(
          textStyle: context.theme.textTheme.titleLarge!.copyWith(
            color: useSmallerNavigationElements
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
        dataSource: DataSource(
          _createAppointments(analysisModelList, context),
        ),
        onTap: _onTap,
        monthCellBuilder: _monthlyBuilder,
      ),
    );
  }

  Widget _monthlyBuilder(BuildContext context, MonthCellDetails details) =>
      MonthCellTile(cellDetails: details);

  // Utility method to create Appointments
  List<Appointment> _createAppointments(
    Set<AnalysisModel> noteModels,
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
      customDialog: DateDialog(date: details.date!),
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
