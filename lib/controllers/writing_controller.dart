import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/note/note_model.dart';
import '../services/firestore_service.dart';
import 'settings/preferences_controller.dart';

int timeWindow = 3;

final writingControllerProvider =
    StateNotifierProvider<WritingController, NoteModel>(
  (ref) => WritingController(),
);

class WritingController extends StateNotifier<NoteModel> {
  // A private constructor.
  WritingController._() : super(NoteModel());

  // The static singleton instance.
  static final WritingController _singleton = WritingController._();

  // A factory constructor that returns the singleton instance.
  factory WritingController() => _singleton;

  final Stopwatch _stopwatch = Stopwatch();
  Timer? _timer;
  Timer? _delayTimer;
  final TextEditingController textController = TextEditingController();
  final isKeyboardOpenProvider = StateProvider((ref) => false);
  static bool writingAutomaticStopwatch = false;

  void handleTextChange(String text) {
    state.content = text.trim();
    if (text.isNotEmpty) {
      if (!_stopwatch.isRunning) {
        _startTimer();
      } else {
        if (writingAutomaticStopwatch) {
          _restartDelayTimer();
        }
      }
    } else if (text.isEmpty) {
      if (writingAutomaticStopwatch) {
        if (_stopwatch.isRunning) {
          _pauseTimerAndLogInput();
        }
        if (_stopwatch.elapsed.inSeconds > 0) {
          state = state.copyWith(duration: _stopwatch.elapsed.inSeconds);
          _stopwatch.reset();
        }
      } else {
        _logInput();
      }
    }
  }

  void _startTimer() async {
    bool automaticStopwatch = await PreferencesController
        .writingAutomaticStopwatch
        .read(); // Read the automatic stopwatch preference
    _stopwatch.start();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      state = state.copyWith(duration: _stopwatch.elapsed.inSeconds);
    });
    if (automaticStopwatch) {
      _delayTimer =
          Timer(Duration(seconds: timeWindow), _pauseTimerAndLogInput);
    }
  }

  void _restartDelayTimer() {
    _delayTimer?.cancel();
    _delayTimer = Timer(Duration(seconds: timeWindow), _pauseTimerAndLogInput);
  }

  void _pauseTimerAndLogInput() async {
    _timer?.cancel();
    _stopwatch.stop();
    _logInput();
  }

  void _logInput() {
    log(
      '$state',
      name: '_logInput():state',
    );
  }

  Future<void> handleSaveNote() async {
    bool automaticStopwatch = await PreferencesController
        .writingAutomaticStopwatch
        .read(); // Read the automatic stopwatch preference
    log(
      'Saved entry: $state',
      name: 'handleSaveNote()',
    );
    _stopwatch.reset();
    _stopwatch.stop();
    _updateOpenAIsSentimentAnalysis(await _openAIsSentimentAnalysis());
    if (automaticStopwatch) {
      _timer?.cancel();
      _delayTimer?.cancel();
    }
    state = state.copyWith(
      timestamp: DateTime.now().millisecondsSinceEpoch,
    );
    await FirestoreService.saveNote(state);
    resetNote();
    textController.clear();
  }

  void resetNote() {
    state = NoteModel();
  }

  void updatePrivate(bool bool) {
    state = state.copyWith(isPrivate: bool);
  }

  Future<int> _openAIsSentimentAnalysis() async {
    final labels = [
      'Very Unpleasant',
      'Unpleasant',
      'Slightly Unpleasant',
      'Neutral',
      'Slightly Pleasant',
      'Pleasant',
      'Very Pleasant'
    ];
    final values = [-3, -2, -1, 0, 1, 2, 3];
    OpenAICompletionModel apiResult = await OpenAI.instance.completion.create(
      model: 'text-davinci-003',
      prompt: '''
Evaluate the sentiment the following text as ${values.join(', ')} for 
${labels.join(', ')} respectively. Please return the sentiment after the 
`Value: ` keyword.

Text:```${state.content}```

Value: ''',
      temperature: 0,
      maxTokens: 60,
      topP: 1,
      frequencyPenalty: 0.5,
      presencePenalty: 0,
      n: 1,
      stop: 'Label:',
      echo: true,
    );
    String response = apiResult.choices.first.text;
    String result = response.split('Value: ').last.trim();
    int sentiment = int.parse(result);
    return sentiment;
  }

  void _updateOpenAIsSentimentAnalysis(int sentiment) async {
    state = state.copyWith(sentiment: sentiment);
  }

  Future<void> updateSentimentAndSaveNote() async {
    _updateOpenAIsSentimentAnalysis(await _openAIsSentimentAnalysis());
    await FirestoreService.saveNote(state);
  }

  Future<void> updateAllUserNotes() async {
    QuerySnapshot<Map<String, dynamic>> collection =
        await FirestoreService.writingCollectionReference()
            .where('isPrivate', isEqualTo: false)
            .get();
    for (QueryDocumentSnapshot<Map<String, dynamic>> element
        in collection.docs) {
      await addOpenAIsSentimentAnalysisToDocument(element);
      // await removeOpenAIsSentimentAnalysisToDocument(element, userId);
    }
  }

  Future<void> addOpenAIsSentimentAnalysisToDocument(
    QueryDocumentSnapshot<Map<String, dynamic>> element,
  ) async {
    if (!element.data().containsKey('sentiment')) {
      state = NoteModel.fromDocument(element.data());
      _updateOpenAIsSentimentAnalysis(await _openAIsSentimentAnalysis());
      await FirestoreService.writingCollectionReference()
          .doc(state.timestamp.toString())
          .update(state.toDocument());
    }
  }

  Future<void> removeOpenAIsSentimentAnalysisToDocument(
    QueryDocumentSnapshot<Map<String, dynamic>> element,
  ) async {
    if (element.data().containsKey('sentiment') ||
        element.data()['isPrivate']) {
      FirestoreService.writingCollectionReference()
          .doc(element.id)
          .update({'sentiment': FieldValue.delete()}).then((_) {
        log(
          'Note has sentiment, removing sentiment',
          name: 'WritingController:updateAllUserNotes():${element.id}',
        );
      }).catchError((error) {
        log(
          '$error',
          name: 'WritingController:updateAllUserNotes():${element.id}',
        );
      });
    }
  }
}
