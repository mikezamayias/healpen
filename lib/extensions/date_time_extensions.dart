import 'dart:developer';

extension DateTimeExtension on DateTime {
  DateTime startOfMonth() {
    DateTime res = DateTime(year, month, 1);
    log('$res', name: 'DateTimeExtension:startOfMonth');
    return res;
  }

  DateTime endOfMonth() {
    DateTime res = DateTime(year, month + 1, 0);
    log('$res', name: 'DateTimeExtension:endOfMonth');
    return res;
  }
  DateTime startOfDay() {
    DateTime res = DateTime(year, month, day);
    log('$res', name: 'DateTimeExtension:startOfDay');
    return res;
  }
}
