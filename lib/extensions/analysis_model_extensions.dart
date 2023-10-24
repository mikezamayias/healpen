import '../models/analysis/analysis_model.dart';
import 'date_time_extensions.dart';
import 'int_extensions.dart';

extension AnalysisModelListExtension on List<AnalysisModel> {
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
              .map((AnalysisModel analysisModel) => analysisModel.sentiment!)
              .reduce((double a, double b) => a + b) /
          analysisModels.length;
      averageDaysSentiment.add(
        AnalysisModel(
          sentiment: averageSentiment,
          timestamp: currentDay.millisecondsSinceEpoch,
        ),
      );
    }
    return averageDaysSentiment;
  }
}
