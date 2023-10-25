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
        ChartData(
          currentDay,
          averageSentiment,
        ),
      );
    }
    return averageDaysSentiment;
  }
}
