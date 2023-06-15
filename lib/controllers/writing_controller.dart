import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/writing_state.dart';

int timeWindow = 2;

final writingControllerProvider =
    StateNotifierProvider<WritingController, WritingState>((ref) {
  return WritingController();
});

class WritingController extends StateNotifier<WritingState> {
  // A private constructor.
  WritingController._() : super(const WritingState());

  // The static singleton instance.
  static final WritingController _singleton = WritingController._();

  // A factory constructor that returns the singleton instance.
  factory WritingController() {
    return _singleton;
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Stopwatch _stopwatch = Stopwatch();
  Timer? _timer;
  Timer? _delayTimer;
  final TextEditingController textController = TextEditingController();

  void handleTextChange(String text) {
    if (text.isNotEmpty) {
      if (!_stopwatch.isRunning) {
        _startTimer();
      } else {
        _restartDelayTimer();
      }
    } else if (text.isEmpty && _stopwatch.isRunning) {
      _pauseTimerAndLogInput();
    }

    state = state.copyWith(text: text);
  }

  void _startTimer() {
    _stopwatch.start();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      state = state.copyWith(seconds: _stopwatch.elapsed.inSeconds);
    });
    _delayTimer = Timer(Duration(seconds: timeWindow), _pauseTimerAndLogInput);
  }

  void _restartDelayTimer() {
    _delayTimer?.cancel();
    _delayTimer = Timer(Duration(seconds: timeWindow), _pauseTimerAndLogInput);
  }

  void _pauseTimerAndLogInput() {
    _timer?.cancel();
    _stopwatch.stop();
    log(
      'Input: ${state.text}',
      name: '_pauseTimerAndLogInput()',
    );
    log(
      'Time spent writing: ${_stopwatch.elapsed.inSeconds} seconds',
      name: '_pauseTimerAndLogInput()',
    );
  }

  Future<void> handleSaveEntry(String userId) async {
    log(
      'Saved entry: ${state.text}',
      name: '_handleSaveEntry()',
    );
    _stopwatch.reset();
    _timer?.cancel();
    _delayTimer?.cancel();
    await _saveEntryToFirebase(userId);
    state = const WritingState();
  }

  Future<void> _saveEntryToFirebase(String userId) {
    log(state.toMap().toString(), name: '_saveEntryToFirebase');
    return _firestore
        .collection('writing-temp')
        .doc(userId)
        .collection('entries')
        .add(state.toMap());
  }

  void resetText() {
    state = state.copyWith(text: '');
  }

  void updatePrivate(bool value) {
    state = state.copyWith(isPrivate: value);
  }
}
