import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/analysis/analysis_model.dart';
import '../services/firestore_service.dart';
import '../utils/constants.dart';

enum AnalysisProgress {
  removingPreviousAnalysis,
  analyzingNotes,
  completed,
}

class AnalysisViewController {
  /// Singleton constructor
  static final AnalysisViewController _instance =
      AnalysisViewController._internal();

  factory AnalysisViewController() => _instance;

  AnalysisViewController._internal();

  /// Attributes
  static final analysisModelList = <AnalysisModel>[];
  static final isAnalysisCompleteProvider = StateProvider<bool>((ref) => false);
  static final progressProvider = StateProvider<int>((ref) => 0);
  static final listToAnalyzeLengthProvider = StateProvider<int>((ref) => 0);
  static final analysisProgressProvider = StateProvider<AnalysisProgress>(
      (ref) => AnalysisProgress.removingPreviousAnalysis);

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

  static Future<void> removePreviousAnalysis(WidgetRef ref) async {
    QuerySnapshot<Map<String, dynamic>> notesToAnalyze =
        await FirestoreService.writingCollectionReference()
            .where('sentiment', isNull: false)
            .get();
    ref.watch(AnalysisViewController.analysisProgressProvider.notifier).state =
        AnalysisProgress.removingPreviousAnalysis;
    ref.watch(AnalysisViewController.progressProvider.notifier).state = 0;
    ref
        .watch(AnalysisViewController.listToAnalyzeLengthProvider.notifier)
        .state = notesToAnalyze.docs.length;
    for (QueryDocumentSnapshot<Map<String, dynamic>> _ in notesToAnalyze.docs) {
      await Future.delayed(standardDuration, () {
        ref.watch(AnalysisViewController.progressProvider.notifier).state++;
      });
    }
  }

  static Future<void> analyzeNotes(WidgetRef ref) async {
    var notesToAnalyze = await FirestoreService.getDocumentsToAnalyze();

    ref.watch(AnalysisViewController.analysisProgressProvider.notifier).state =
        AnalysisProgress.analyzingNotes;
    ref.watch(AnalysisViewController.progressProvider.notifier).state = 0;
    ref
        .watch(AnalysisViewController.listToAnalyzeLengthProvider.notifier)
        .state = notesToAnalyze.length;

    for (DocumentSnapshot<Map<String, dynamic>> note in notesToAnalyze) {
      log(
        note.id,
        name: 'AnalysisViewController:analyzeNotes() - note ID',
      );
      log(
        note.get('content'),
        name: 'AnalysisViewController:analyzeNotes() - note content',
      );
      // await WritingController().analyzeSentiment(noteModel);
      await Future.delayed(standardDuration, () {
        ref.watch(AnalysisViewController.progressProvider.notifier).state++;
      });
    }
  }

  static Future<void> completed(WidgetRef ref) async {
    await AnalysisViewController.removePreviousAnalysis(ref);
    await AnalysisViewController.analyzeNotes(ref);
    ref.watch(AnalysisViewController.analysisProgressProvider.notifier).state =
        AnalysisProgress.completed;
  }
}
