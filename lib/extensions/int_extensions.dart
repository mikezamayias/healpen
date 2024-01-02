import 'date_time_extensions.dart';

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

  DateTime timestampToDateTime() {
    return DateTime.fromMillisecondsSinceEpoch(this);
  }

  String timestampToEEEEMMMdHHMM() {
    return timestampToDateTime().toEEEEMMMdHHMM();
  }

  String timestampToEEEEMMMd() {
    return timestampToDateTime().toEEEEMMMd();
  }

  String timestampToHHMM() {
    return timestampToDateTime().toHHMM();
  }
}
