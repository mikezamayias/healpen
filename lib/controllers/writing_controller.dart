import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

  void handleTextChange(String text) {
    PreferencesController()
        .writingAutomaticStopwatch
        .read()
        .then((bool automaticStopwatch) {
      state.content = text.trim();
      log('$state', name: 'WritingController:handleTextChange');
      if (text.isNotEmpty) {
        if (!_stopwatch.isRunning) {
          _startTimer();
        } else {
          if (automaticStopwatch) {
            _restartDelayTimer();
          }
        }
      } else if (text.isEmpty) {
        if (automaticStopwatch) {
          if (_stopwatch.isRunning) {
            _pauseTimerAndLogInput();
          }
          if (_stopwatch.elapsed.inSeconds > 0) {
            _stopwatch.reset();
            state =
                state.copyWith(duration: 0); // Reset the seconds in the state
          }
        } else {
          _logInput();
        }
      }
    });
  }

  void _startTimer() async {
    bool automaticStopwatch = await PreferencesController()
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

  void _pauseTimerAndLogInput() {
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

  Future handleSaveNote() async {
    bool automaticStopwatch = await PreferencesController()
        .writingAutomaticStopwatch
        .read(); // Read the automatic stopwatch preference
    log(
      'Saved entry: $state',
      name: 'handleSaveNote()',
    );
    _stopwatch.reset();
    _stopwatch.stop();
    if (automaticStopwatch) {
      _timer?.cancel();
      _delayTimer?.cancel();
    }
    _saveNoteToFirebase().whenComplete(() {
      textController.clear();
      resetNote();
    });
  }

  Future<void> _saveNoteToFirebase() {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    log(
      state.toDocument().toString(),
      name: '_saveEntryToFirebase(userId: $userId)',
    );
    state = state.copyWith(
      timestamp: DateTime.now().millisecondsSinceEpoch,
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
    state = state.copyWith(isPrivate: bool);
  }
}
