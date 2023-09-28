import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  static final isAnalysisCompleteProvider = StateProvider<bool>((ref) => false);

  /// Methods
  Stream<QuerySnapshot<Map<String, dynamic>>> get analysisStream =>
      FirestoreService.analysisCollectionReference().snapshots();

  Stream<List<AnalysisModel>> get metricGroupingsStream =>
      analysisStream.map((event) {
        analysisModelList.clear();
        for (QueryDocumentSnapshot<Map<String, dynamic>> element
            in event.docs) {
          analysisModelList.add(AnalysisModel.fromJson(element.data()));
        }
        return analysisModelList;
      });
}
