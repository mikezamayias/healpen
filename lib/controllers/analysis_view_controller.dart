import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/analysis/analysis_model.dart';
import '../services/firestore_service.dart';

class AnalysisViewController {
  /// Singleton constructor
  static final AnalysisViewController _instance =
      AnalysisViewController._internal();

  factory AnalysisViewController() => _instance;

  AnalysisViewController._internal();

  /// Attributes
  static final analysisModelList = <AnalysisModel>[];

  /// Methods
  Stream<QuerySnapshot<Map<String, dynamic>>> get analysisStream =>
      FirestoreService.analysisCollectionReference().snapshots();

  Stream<List<AnalysisModel>> get metricGroupingsStream =>
      analysisStream.map((event) {
        analysisModelList.clear();
        for (QueryDocumentSnapshot<Map<String, dynamic>> element
            in event.docs) {
          log(
            '${element.data()} - ${element.data().values.first} - ${element.id}',
            name: 'AnalysisViewController:metricsStream',
          );
          analysisModelList.add(AnalysisModel.fromJson(element.data()));
        }
        return analysisModelList;
      });
}
