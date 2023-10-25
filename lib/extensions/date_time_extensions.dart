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
}
