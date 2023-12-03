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
import 'settings/firestore_preferences_controller.dart';
import 'settings/preferences_controller.dart';

enum AnalysisProgress {
  removingPreviousAnalysis,
  analyzingNotes,
  completed,
}

class NoteAnalyzer {
  final FirestoreService firestoreService;
  final CloudNaturalLanguageApi cloudNaturalLanguageApi;

  NoteAnalyzer._internal(this.firestoreService, this.cloudNaturalLanguageApi);

  static final NoteAnalyzer _instance = NoteAnalyzer._internal(
    FirestoreService(),
    CloudNaturalLanguageApi(clientViaApiKey(Env.googleApisKey)),
  );

  factory NoteAnalyzer() => _instance;

  static final analysisProgressProvider = StateProvider<AnalysisProgress>(
    (ref) => AnalysisProgress.removingPreviousAnalysis,
  );
  static final isAnalysisCompleteProvider = StateProvider<bool>((ref) => false);
  static final progressProvider = StateProvider<int>((ref) => 0);
  static final listToAnalyzeLengthProvider = StateProvider<int>((ref) => 0);

  Future<void> removePreviousAnalysis(WidgetRef ref) async {
    final documentsToRemoveAnalysis =
        await firestoreService.getWritingDocumentsToRemoveAnalysis();
    _updateProgress(ref, AnalysisProgress.removingPreviousAnalysis,
        documentsToRemoveAnalysis.length);
    for (DocumentSnapshot<NoteModel> note in documentsToRemoveAnalysis) {
      _logNoteDetails(note);
      await firestoreService.removeAnalysisFromWritingDocument(note);
      _incrementProgress(ref);
    }
  }

  Future<void> analyzeNotes(WidgetRef ref) async {
    var notesToAnalyze = await firestoreService.getDocumentsToAnalyze();
    _updateProgress(
        ref, AnalysisProgress.analyzingNotes, notesToAnalyze.length);
    for (DocumentSnapshot<NoteModel> noteModel in notesToAnalyze) {
      _logNoteDetails(noteModel);
      await firestoreService.analyzeSentiment(noteModel);
      _incrementProgress(ref);
    }
  }

  Future<void> finishAnalysis(WidgetRef ref) async {
    await analyzeNotes(ref);
    _updateProgress(ref, AnalysisProgress.completed, 0);
    ref.read(writingShowAnalyzeNotesButtonProvider.notifier).state = false;
    await FirestorePreferencesController().savePreference(
      PreferencesController.writingShowAnalyzeNotesButton
          .withValue(ref.watch(writingShowAnalyzeNotesButtonProvider)),
    );
  }

  Future<AnalysisModel> createNoteAnalysis(NoteModel noteModel) async {
    AnalyzeSentimentResponse result =
        await cloudNaturalLanguageApi.documents.analyzeSentiment(
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
      duration: noteModel.duration,
      content: noteModel.content,
      score: result.documentSentiment!.score!,
      magnitude: result.documentSentiment!.magnitude!,
      language: result.language!,
      sentences: <SentenceModel>[
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
      name: 'FirestoreService:analyzeSentiment',
    );
    return analysisModel;
  }

  void _updateProgress(WidgetRef ref, AnalysisProgress progress, int length) {
    ref.watch(analysisProgressProvider.notifier).state = progress;
    ref.watch(progressProvider.notifier).state = 0;
    ref.watch(listToAnalyzeLengthProvider.notifier).state = length;
  }

  void _incrementProgress(WidgetRef ref) {
    ref.watch(progressProvider.notifier).state++;
  }

  void _logNoteDetails(DocumentSnapshot<NoteModel> note) {
    log(
      note.id,
      name: 'AnalysisViewController:removePreviousAnalysis() - note ID',
    );
    log(
      note.get('content'),
      name: 'AnalysisViewController:removePreviousAnalysis() - note content',
    );
  }
}
