import 'dart:developer';

import '../models/analysis/analysis_model.dart';
import '../models/analysis/chart_data_model.dart';
import 'date_time_extensions.dart';
import 'int_extensions.dart';

extension AnalysisModelListExtension on List<AnalysisModel> {
  List<ChartData> averageDaysSentiment() {
    final List<ChartData> averageDaysSentiment = [];
    final List<DateTime> days = map(
      (AnalysisModel analysisModel) =>
          analysisModel.timestamp.timestampToDateTime().startOfDay(),
    ).toList();
    final List<DateTime> uniqueDays = days.toSet().toList();
    for (int i = 0; i < uniqueDays.length; i++) {
      final DateTime currentDay = uniqueDays.elementAt(i);
      log(currentDay.toString(), name: 'currentDay');
      final List<AnalysisModel> analysisModels = where(
        (AnalysisModel analysisModel) =>
            analysisModel.timestamp.timestampToDateTime().startOfDay() ==
            currentDay,
      ).toList();
      log(analysisModels.length.toString(), name: 'analysisModels');
      final double averageSentiment = analysisModels
              .map((AnalysisModel analysisModel) => analysisModel.sentiment!)
              .reduce((double a, double b) => a + b) /
          analysisModels.length;
      log(averageSentiment.toString(), name: 'averageSentiment');
      averageDaysSentiment.add(
        ChartData(
          currentDay,
          averageSentiment,
        ),
      );
    }
    log(
      averageDaysSentiment.toString(),
      name: 'averageDaysSentiment.length',
    );
    return averageDaysSentiment;
  }
}
