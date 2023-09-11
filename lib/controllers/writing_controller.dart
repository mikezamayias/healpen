import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_openai/dart_openai.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
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
          _stopwatch.reset();
          state = state.copyWith(duration: 0); // Reset the seconds in the
          // state
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
    log(
      response,
      name: 'WritingController:_openAIsSentimentAnalysis():response',
    );
    String result = response.split('Value: ').last.trim();
    log(
      'Result: $result',
      name: 'WritingController:_openAIsSentimentAnalysis()',
    );
    int sentiment = int.parse(result);
    return sentiment;
  }

  void _updateOpenAIsSentimentAnalysis(int sentiment) async {
    log(
      'Updating sentiment analysis',
      name: 'WritingController:_updateOpenAIsSentimentAnalysis()',
    );
    state = state.copyWith(sentiment: sentiment);
  }

  Future<void> updateSentimentAndSaveNote() async {
    log(
      'Updating sentiment and saving note',
      name: 'WritingController:updateSentimentAndSaveNote()',
    );
    _updateOpenAIsSentimentAnalysis(await _openAIsSentimentAnalysis());
    await FirestoreService.saveNote(state);
  }

  Future<void> updateAllUserNotes() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    QuerySnapshot<Map<String, dynamic>> collection = await _firestore
        .collection('writing-temp')
        .doc(userId)
        .collection('notes')
        .where('isPrivate', isEqualTo: false)
        .get();
    for (QueryDocumentSnapshot<Map<String, dynamic>> element
        in collection.docs) {
      await addOpenAIsSentimentAnalysisToDocument(element, userId);
      // await removeOpenAIsSentimentAnalysisToDocument(element, userId);
    }
  }

  Future<void> addOpenAIsSentimentAnalysisToDocument(
    QueryDocumentSnapshot<Map<String, dynamic>> element,
    String userId,
  ) async {
    if (!element.data().containsKey('sentiment')) {
      log(
        'Note is missing sentiment analysis, updating sentiment',
        name: 'WritingController:updateAllUserNotes():${element.id}',
      );
      log(
        '${element.data()}',
        name: 'WritingController:updateAllUserNotes():${element.id}',
      );
      state = NoteModel.fromDocument(element.data());
      _updateOpenAIsSentimentAnalysis(await _openAIsSentimentAnalysis());
      log(
        '$state',
        name:
            'WritingController:updateAllUserNotes():${element.id}:NoteModel.fromDocument(element.data())',
      );
      await FirestoreService.writingCollectionReference()
          .doc(state.timestamp.toString())
          .update(state.toDocument());
    }
  }

  Future<void> removeOpenAIsSentimentAnalysisToDocument(
    QueryDocumentSnapshot<Map<String, dynamic>> element,
    String userId,
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
