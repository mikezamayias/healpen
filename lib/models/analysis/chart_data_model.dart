import 'package:intl/intl.dart';

class ChartData {
  ChartData(this.x, this.y);

  final DateTime x;
  late final double? y;

  @override
  String toString() {
    return 'ChartData(x: ${DateFormat('yyyy MMMM dd').format(x)}, y: $y)';
  }
}
