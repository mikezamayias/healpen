import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

class AnalysisViewController {
  /// Singleton constructor
  static final AnalysisViewController _instance =
      AnalysisViewController._internal();

  factory AnalysisViewController() => _instance;

  AnalysisViewController._internal();

  /// Attributes
  final _db = FirebaseFirestore.instance;
  final _metricGroupingEntries = <String>[];

  /// Methods
  Stream<QuerySnapshot<Map<String, dynamic>>> get analysisStream =>
      _db.collection('analysis-temp').snapshots();

  Stream<List<String>> get metricGroupingsStream => analysisStream.map((event) {
        _metricGroupingEntries.clear();
        for (QueryDocumentSnapshot<Map<String, dynamic>> element
            in event.docs) {
          log(
            '${element.data()} - ${element.data().values.first} - ${element.id}',
            name: 'AnalysisViewController:metricsStream',
          );
          _metricGroupingEntries.add('${element.data().values.first}');
        }
        return _metricGroupingEntries;
      });
}
