import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  DateTime startOfMonth() {
    DateTime res = DateTime(year, month, 1);
    return res;
  }

  DateTime endOfMonth() {
    DateTime res = DateTime(year, month + 1, 0);
    return res;
  }

  DateTime startOfDay() {
    DateTime res = DateTime(year, month, day);
    return res;
  }

  DateTime endOfDay() {
    DateTime res = DateTime(year, month, day + 1);
    return res;
  }

  DateTime startOfWeek() {
    DateTime res = DateTime(year, month, day - weekday + 1);
    return res;
  }

  DateTime endOfWeek() {
    DateTime res = DateTime(year, month, day + (7 - weekday));
    return res;
  }

  int weeksBefore(DateTime date) {
    return date.difference(this).inDays ~/ 7;
  }

  bool isBetween({required DateTime start, required DateTime end}) {
    return isAfter(start) && isBefore(end);
  }

  String toLineChartTitle() {
    final delta = weeksBefore(DateTime.now());
    return switch (delta) {
      0 => 'This week',
      1 => 'Last week',
      _ => '$delta weeks ago',
    };
  }

  bool isStartOfMonth() {
    return isSameDate(DateTime(year, month, 1));
  }

  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  String toEEEEMMMd() {
    return DateFormat('EEEE, MMM d').format(this);
  }

  String toHHMM() {
    return DateFormat('HH:MM').format(this);
  }

  String toEEEEMMMdHHMM() {
    return '${toEEEEMMMd()} ${toHHMM()}';
  }
}
