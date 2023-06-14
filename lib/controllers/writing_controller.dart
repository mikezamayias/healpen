import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/writing_state.dart';

final writingControllerProvider =
    StateNotifierProvider<WritingController, WritingState>((ref) {
  return WritingController();
});

class WritingController extends StateNotifier<WritingState> {
  WritingController() : super(const WritingState());

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Stopwatch _stopwatch = Stopwatch();
  Timer? _timer;
  Timer? _delayTimer;

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
    _delayTimer = Timer(const Duration(seconds: 3), _pauseTimerAndLogInput);
  }

  void _restartDelayTimer() {
    _delayTimer?.cancel();
    _delayTimer = Timer(const Duration(seconds: 3), _pauseTimerAndLogInput);
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
    return _firestore
        .collection('writingEntries')
        .doc(userId)
        .set(state.toMap());
  }

  void updatePrivate(bool value) {
    state = state.copyWith(isPrivate: value);
  }
}
