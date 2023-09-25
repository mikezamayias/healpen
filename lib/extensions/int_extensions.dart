extension IntExtension on int {
  String writingDurationFormat() {
    final hours = this ~/ 3600;
    final minutes = (this % 3600) ~/ 60;
    final seconds = this % 60;

    String hoursStr = (hours > 0) ? '${hours.toString().padLeft(2, '0')}:' : '';
    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = seconds.toString().padLeft(2, '0');

    return '$hoursStr$minutesStr:$secondsStr';
  }

  String timestampFormat() {
    final DateTime date = DateTime.fromMillisecondsSinceEpoch(this);
    final String year = date.year.toString();
    final String month = date.month.toString().padLeft(2, '0');
    final String day = date.day.toString().padLeft(2, '0');
    final String hour = date.hour.toString().padLeft(2, '0');
    final String minute = date.minute.toString().padLeft(2, '0');
    final String second = date.second.toString().padLeft(2, '0');

    return '$year-$month-$day, $hour:$minute:$second';
  }

  DateTime timestampToDateTime() {
    return DateTime.fromMillisecondsSinceEpoch(this);
  }
}
