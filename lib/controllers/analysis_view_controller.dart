import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/note/note_model.dart';
import '../services/firestore_service.dart';

class AnalysisViewController {
  /// Singleton constructor
  static final AnalysisViewController _instance =
      AnalysisViewController._internal();

  factory AnalysisViewController() => _instance;

  AnalysisViewController._internal();

  /// Attributes
  final _metricGroupingEntries = <NoteModel>[];

  /// Methods
  Stream<QuerySnapshot<Map<String, dynamic>>> get analysisStream =>
      FirestoreService.writingCollectionReference()
          .where('isPrivate', isEqualTo: false)
          .snapshots();

  Stream<List<NoteModel>> get metricGroupingsStream =>
      analysisStream.map((event) {
        _metricGroupingEntries.clear();
        for (QueryDocumentSnapshot<Map<String, dynamic>> element
            in event.docs) {
          log(
            '${element.data()} - ${element.data().values.first} - ${element.id}',
            name: 'AnalysisViewController:metricsStream',
          );
          _metricGroupingEntries.add(NoteModel.fromDocument(element.data()));
        }
        return _metricGroupingEntries;
      });
}
