import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/note/note_model.dart';
import '../services/firestore_service.dart';
import '../utils/logger.dart';
import 'note_analyzer.dart';

int timeWindow = 3;

final writingControllerProvider =
    StateNotifierProvider<WritingController, NoteModel>(
  (ref) => WritingController(),
);

class WritingController extends StateNotifier<NoteModel> {
  WritingController._() : super(NoteModel());

  static final WritingController _singleton = WritingController._();

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
    _stopwatch.start();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      state = state.copyWith(duration: _stopwatch.elapsed.inSeconds);
    });
    if (writingAutomaticStopwatch) {
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
    logger.i('$state');
  }

  Future<void> handleSaveNote() async {
    logger.i('WritingController.handleSaveNote()');
    _stopwatch.reset();
    _stopwatch.stop();
    if (writingAutomaticStopwatch) {
      _timer?.cancel();
      _delayTimer?.cancel();
    }
    state = state.copyWith(
      timestamp: DateTime.now().millisecondsSinceEpoch,
    );
    final analysis = await NoteAnalyzer().createNoteAnalysis(state);
    FirestoreService().saveAnalysis(analysis);
    FirestoreService().saveNote(state);
    resetController();
    logger.i('Saved entry: $state');
  }

  void resetNote() {
    state = NoteModel();
  }

  void resetController() {
    _stopwatch.reset();
    _stopwatch.stop();
    _timer?.cancel();
    _delayTimer?.cancel();
    resetNote();
    textController.clear();
  }

  void updatePrivate(bool bool) {
    state = state.copyWith(isPrivate: bool);
  }
}
