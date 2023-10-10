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
  static final analysisModelListProvider = StateProvider(
    (ref) => <AnalysisModel>[],
  );

  /// Methods
  static Stream<QuerySnapshot<Map<String, dynamic>>> analysisStream() =>
      FirestoreService.analysisCollectionReference().snapshots();

  static analyzeNotes(WidgetRef ref) {}
}
