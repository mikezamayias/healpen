import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/analysis/analysis_model.dart';
import 'firestore_service.dart';

class HourlyData {
  final int hour;
  final int totalWritingTime;
  final double? averageSentiment;

  HourlyData(this.hour, this.totalWritingTime, this.averageSentiment);

  factory HourlyData.empty(int hour) => HourlyData(hour, 0, null);

  @override
  String toString() {
    return 'HourlyData{hour: $hour, totalWritingTime: $totalWritingTime, '
        'averageSentiment: $averageSentiment}';
  }
}

class DataAnalysisService {
  static final DataAnalysisService _instance = DataAnalysisService._internal();

  factory DataAnalysisService() {
    return _instance;
  }

  DataAnalysisService._internal();

  Stream<List<HourlyData>> getHourlyData() {
    return FirestoreService()
        .analysisCollectionReference()
        .snapshots()
        .map(_analyzeHourlyData);
  }

  List<HourlyData> _analyzeHourlyData(
    QuerySnapshot<AnalysisModel> querySnapshot,
  ) {
    final Map<int, HourlyDataBuilder> dataBuilders = {};
    for (QueryDocumentSnapshot<AnalysisModel> doc in querySnapshot.docs) {
      final analysis = doc.data();
      final hour = DateTime.fromMillisecondsSinceEpoch(analysis.timestamp).hour;
      final builder = dataBuilders.putIfAbsent(hour, () => HourlyDataBuilder());
      builder.addAnalysis(analysis);
    }
    List<HourlyData> res = List.generate(
      24,
      (hour) => dataBuilders[hour]?.build(hour) ?? HourlyData.empty(hour),
    );
    return res;
  }
}

class HourlyDataBuilder {
  int _totalWritingTime = 0;
  double _totalSentiment = 0.0;
  int _analysisCount = 0;

  void addAnalysis(AnalysisModel analysis) {
    _totalWritingTime +=
        analysis.wordCount!; // Assuming each word takes about a second to write
    _totalSentiment += analysis.sentiment!;
    _analysisCount++;
  }

  HourlyData build(int hour) {
    return HourlyData(
      hour,
      _totalWritingTime,
      _analysisCount > 0 ? _totalSentiment / _analysisCount : 0.0,
    );
  }
}
