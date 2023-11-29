import 'dart:developer';

import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';

import '../models/analysis/analysis_model.dart';
import '../models/analysis/chart_data_model.dart';
import '../services/data_analysis_service.dart';
import 'date_time_extensions.dart';
import 'int_extensions.dart';

extension AnalysisModelListExtension on List<AnalysisModel> {
  List<ChartData> averageDaysSentimentToChartData() {
    final List<ChartData> result = averageDaysSentiment().toChartData();
    return result;
  }

  List<ChartData> toChartData() {
    final List<ChartData> result = map(
      (AnalysisModel element) => ChartData(
        element.timestamp.timestampToDateTime(),
        element.score,
      ),
    ).toList();
    return result;
  }

  Set<DateTime> getMonthsFromAnalysisModelList() {
    List<DateTime> monthList = <DateTime>[];
    for (var analysisModel in this) {
      var month = DateTime.fromMillisecondsSinceEpoch(
        analysisModel.timestamp,
      ).month;
      var year = DateTime.fromMillisecondsSinceEpoch(
        analysisModel.timestamp,
      ).year;
      monthList.add(DateTime(year, month));
    }
    return monthList.toSet();
  }

  /// Generates a set of [DateTime] objects representing the start of each
  /// week between [lastAnalysisDateTime] and [start].
  ///
  /// The generated [DateTime] objects are in reverse order and do not contain
  /// duplicate values.
  ///
  /// Returns:
  ///   - A [Set] of [DateTime] objects representing the start of each week.
  ///
  /// Example usage:
  /// ```dart
  /// final startOfWeekList = generateStartOfWeekList();
  /// print(startOfWeekList); // {2022-01-30, 2022-01-23, 2022-01-16, ...}
  /// ```
  Set<DateTime> generateStartOfWeeksFromEndSet() {
    final start = DateTime.parse(
      DateFormat('yyyy-MM-dd').format(
        last.timestamp.timestampToDateTime(),
      ),
    );
    final lastAnalysisDateTime = DateTime.parse(
      DateFormat('yyyy-MM-dd').format(
        first.timestamp.timestampToDateTime(),
      ),
    );
    List<DateTime> startOfWeekList = <DateTime>[];
    for (DateTime date = lastAnalysisDateTime;
        date.isBefore(start);
        date = date.add(const Duration(days: 7))) {
      startOfWeekList.add(date);
    }
    log(
      startOfWeekList.map((e) => DateFormat('yyyy-MM-dd').format(e)).join(', '),
      name:
          'AnalysisModelListExtension:generateStartOfWeekList:startOfWeekList',
    );
    return startOfWeekList.toSet();
  }

  Set<DateTime> generateWeekSet() {
    final tempWeekSet = generateStartOfWeeksFromEndSet();
    final weekSet = <DateTime>{};
    for (DateTime week in tempWeekSet) {
      final start = week.subtract(7.days);
      final end = week;
      if (any(
        (note) =>
            note.timestamp.timestampToDateTime().isAfter(start) &&
            note.timestamp.timestampToDateTime().isBefore(end),
      )) {
        weekSet.add(week);
      }
    }
    return weekSet;
  }

  List<AnalysisModel> averageDaysSentiment() {
    final List<AnalysisModel> averageDaysSentiment = [];
    final List<DateTime> days = map(
      (AnalysisModel analysisModel) =>
          analysisModel.timestamp.timestampToDateTime().startOfDay(),
    ).toList();
    final List<DateTime> uniqueDays = days.toSet().toList();
    for (int i = 0; i < uniqueDays.length; i++) {
      final DateTime currentDay = uniqueDays.elementAt(i);
      final List<AnalysisModel> analysisModels = where(
        (AnalysisModel analysisModel) =>
            analysisModel.timestamp.timestampToDateTime().startOfDay() ==
            currentDay,
      ).toList();
      final double averageSentiment = analysisModels
              .map((AnalysisModel analysisModel) => analysisModel.score)
              .reduce((double a, double b) => a + b) /
          analysisModels.length;
      averageDaysSentiment.add(
        AnalysisModel(
          timestamp: currentDay.millisecondsSinceEpoch,
          score: double.parse(averageSentiment.toStringAsFixed(2)),
        ),
      );
    }
    return averageDaysSentiment;
  }

  List<AnalysisModel> getAnalysisBetweenDates({
    required DateTime start,
    required DateTime end,
  }) {
    return where(
      (AnalysisModel analysisModel) =>
          analysisModel.timestamp.timestampToDateTime().isBetween(
                start: start,
                end: end,
              ),
    ).toList();
  }

  List<HourlyData> hourlyAnalysis() {
    final Map<int, HourlyDataBuilder> dataBuilders = {};
    for (AnalysisModel analysisModel in this) {
      final hour =
          DateTime.fromMillisecondsSinceEpoch(analysisModel.timestamp).hour;
      final builder = dataBuilders.putIfAbsent(hour, () => HourlyDataBuilder());
      builder.addAnalysis(analysisModel);
    }
    List<HourlyData> processedData = List.generate(
      24,
      (hour) => dataBuilders[hour]?.build(hour) ?? HourlyData.empty(hour),
    );
    return processedData;
  }
}
