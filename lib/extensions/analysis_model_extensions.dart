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
