import 'package:collection/collection.dart';
import 'package:intl/intl.dart';

import '../models/analysis/chart_data_model.dart';

extension ChartDataExtensions on List<ChartData> {
  /// Inserts null values in the chart data list for dates after [start] and
  /// before [end].
  /// This is done to ensure that the line chart displays a continuous line
  ///
  /// The chart data list is modified in-place.
  ///
  /// Parameters:
  /// - [start]: The start date from which to insert null values.
  /// - [end]: The end date until which to insert null values.
  ///
  /// Returns: void
  List<ChartData> insertNullValuesBetween({
    required DateTime start,
    required DateTime end,
  }) {
    List<ChartData> tempList = <ChartData>[
      for (DateTime date = end;
          date.isAfter(start);
          date = date.subtract(const Duration(days: 1)))
        ChartData(date, null)
    ];
    tempList.removeWhere((ChartData element) =>
        map((ChartData e) => DateFormat('yyyy-MM-dd').format(e.x))
            .contains(DateFormat('yyyy-MM-dd').format(element.x)));
    tempList.addAll(this);
    return tempList.sorted((a, b) => a.x.compareTo(b.x));
  }
}
