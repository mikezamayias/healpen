import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:googleapis/language/v1.dart';
import 'package:googleapis_auth/googleapis_auth.dart';

import '../env/env.dart';
import '../models/note/note_model.dart';
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
  final shakePrivateNoteInfoProvider = StateProvider((ref) {
    log('shakePrivateNoteInfoProvider', name: 'WritingController');
    return true;
  });
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
          state = state.copyWith(null, duration: 0); // Reset the seconds in the
          // state
        }
      } else {
        _logInput();
      }
    }
  }

  void _startTimer() async {
    bool automaticStopwatch = await PreferencesController()
        .writingAutomaticStopwatch
        .read(); // Read the automatic stopwatch preference
    _stopwatch.start();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      state = state.copyWith(null, duration: _stopwatch.elapsed.inSeconds);
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
    bool automaticStopwatch = await PreferencesController()
        .writingAutomaticStopwatch
        .read(); // Read the automatic stopwatch preference
    log(
      'Saved entry: $state',
      name: 'handleSaveNote()',
    );
    _stopwatch.reset();
    _stopwatch.stop();
    _updateSentimentAnalysis(await _sentimentAnalysis());
    if (automaticStopwatch) {
      _timer?.cancel();
      _delayTimer?.cancel();
    }
    state = state.copyWith(
      null,
      timestamp: DateTime.now().millisecondsSinceEpoch,
    );
    await _saveNoteToFirebase();
    textController.clear();
    resetNote();
  }

  Future<void> _saveNoteToFirebase() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    log(
      state.toDocument().toString(),
      name: '_saveEntryToFirebase(userId: $userId)',
    );
    return _firestore
        .collection('writing-temp')
        .doc(userId)
        .collection('notes')
        .doc(state.timestamp.toString())
        .set(state.toDocument());
  }

  void resetNote() {
    state = NoteModel();
  }

  void updatePrivate(bool bool) {
    state = state.copyWith(null, isPrivate: bool);
  }

  Future<AnalyzeSentimentResponse> _sentimentAnalysis() async {
    return await CloudNaturalLanguageApi(clientViaApiKey(Env.googleApisKey))
        .documents
        .analyzeSentiment(
          AnalyzeSentimentRequest.fromJson(
            {
              'document': {
                'type': 'PLAIN_TEXT',
                'content': state.content,
              },
              'encodingType': 'UTF8',
            },
          ),
        );
  }

  void _updateSentimentAnalysis(AnalyzeSentimentResponse response) {
    log(
      'Updating sentiment analysis',
      name: 'WritingController:_updateSentimentAnalysis()',
    );
    state = state.copyWith(
      null,
      sentimentScore: response.documentSentiment?.score,
      sentimentMagnitude: response.documentSentiment?.magnitude,
      sentenceCount: response.sentences?.length,
      sentiment: calculateSentiment(
        response.documentSentiment?.score,
        response.documentSentiment?.magnitude,
      ),
    );
  }
}
