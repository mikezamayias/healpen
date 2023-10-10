import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class JournalingRhythmTile extends StatelessWidget {
  const JournalingRhythmTile({super.key});

  @override
  Widget build(BuildContext context) {
    return SfCalendar(
      headerDateFormat: 'MMMM d, yyyy',
      view: CalendarView.month,
      monthViewSettings: const MonthViewSettings(showAgenda: false),
    );
  }
}
