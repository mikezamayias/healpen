import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:googleapis/language/v1.dart';
import 'package:googleapis_auth/googleapis_auth.dart';

import '../env/env.dart';
import '../models/analysis/analysis_model.dart';
import '../models/note/note_model.dart';
import '../models/sentence/sentence_model.dart';
import '../providers/settings_providers.dart';
import '../services/firestore_service.dart';
import 'settings/preferences_controller.dart';

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
  static final analysisModelListProvider = StateProvider(
    (ref) => <AnalysisModel>[],
  );
  static final isAnalysisCompleteProvider = StateProvider<bool>((ref) => false);
  static final progressProvider = StateProvider<int>((ref) => 0);
  static final listToAnalyzeLengthProvider = StateProvider<int>((ref) => 0);
  static final analysisProgressProvider = StateProvider<AnalysisProgress>(
    (ref) => AnalysisProgress.removingPreviousAnalysis,
  );

  /// Methods
  static Stream<QuerySnapshot<Map<String, dynamic>>> analysisStream() =>
      FirestoreService.analysisCollectionReference().snapshots();

  static Future<void> removePreviousAnalysis(WidgetRef ref) async {
    final documentsToRemoveAnalysis =
        await FirestoreService.getWritingDocumentsToRemoveAnalysis();
    ref.watch(AnalysisViewController.analysisProgressProvider.notifier).state =
        AnalysisProgress.removingPreviousAnalysis;
    ref.watch(AnalysisViewController.progressProvider.notifier).state = 0;
    ref
        .watch(AnalysisViewController.listToAnalyzeLengthProvider.notifier)
        .state = documentsToRemoveAnalysis.length;
    for (DocumentSnapshot<Map<String, dynamic>> note
        in documentsToRemoveAnalysis) {
      log(
        note.id,
        name: 'AnalysisViewController:removePreviousAnalysis() - note ID',
      );
      log(
        note.get('content'),
        name: 'AnalysisViewController:removePreviousAnalysis() - note content',
      );
      await FirestoreService.removeAnalysisFromWritingDocument(note);
      ref.watch(AnalysisViewController.progressProvider.notifier).state++;
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
      await FirestoreService.analyzeSentiment(note);
      ref.watch(AnalysisViewController.progressProvider.notifier).state++;
    }
  }

  static Future<void> completed(WidgetRef ref) async {
    // await AnalysisViewController.removePreviousAnalysis(ref);
    await AnalysisViewController.analyzeNotes(ref);
    ref.watch(AnalysisViewController.analysisProgressProvider.notifier).state =
        AnalysisProgress.completed;
    ref.read(writingShowAnalyzeNotesButtonProvider.notifier).state = false;
    await PreferencesController.writingShowAnalyzeNotesButton
        .write(ref.watch(writingShowAnalyzeNotesButtonProvider));
  }

  static Future<AnalysisModel> createNoteAnalysis(NoteModel noteModel) async {
    AnalyzeSentimentResponse result =
        await CloudNaturalLanguageApi(clientViaApiKey(Env.googleApisKey))
            .documents
            .analyzeSentiment(
              AnalyzeSentimentRequest.fromJson(
                {
                  'document': {
                    'type': 'PLAIN_TEXT',
                    'content': noteModel.content,
                  },
                  'encodingType': 'UTF32',
                },
              ),
            );
    AnalysisModel analysisModel = AnalysisModel(
      timestamp: noteModel.timestamp,
      content: noteModel.content,
      score: result.documentSentiment!.score!,
      magnitude: result.documentSentiment!.magnitude!,
      language: result.language!,
      sentences: [
        for (Sentence sentence in result.sentences!)
          SentenceModel(
            content: sentence.text!.content!,
            score: sentence.sentiment!.score!,
            magnitude: sentence.sentiment!.magnitude!,
          ),
      ],
    );
    log(
      '${analysisModel.toJson()}',
      name: 'FirestorService:analyzeSentiment',
    );
    return analysisModel;
  }
}
