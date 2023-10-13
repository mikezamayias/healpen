import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:googleapis/language/v1.dart';

import '../models/note/note_model.dart';
import '../services/firestore_service.dart';
import 'note_analyzer.dart';
import 'settings/firestore_preferences_controller.dart';
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
    bool automaticStopwatch = (await FirestorePreferencesController()
            .getPreference(PreferencesController.writingAutomaticStopwatch))!
        .value;
    // Read the automatic stopwatch preference
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
    bool automaticStopwatch = (await FirestorePreferencesController()
            .getPreference(PreferencesController.writingAutomaticStopwatch))!
        .value;
    // Read
    // the automatic stopwatch
    // preference
    log(
      'Saved entry: $state',
      name: 'handleSaveNote()',
    );
    _stopwatch.reset();
    _stopwatch.stop();
    // await _sentimentAnalysis();
    if (automaticStopwatch) {
      _timer?.cancel();
      _delayTimer?.cancel();
    }
    state = state.copyWith(
      timestamp: DateTime.now().millisecondsSinceEpoch,
    );
    await FirestoreService.saveNote(state);
    if (!state.isPrivate) {
      await FirestoreService.saveAnalysis(
          await NoteAnalyzer.createNoteAnalysis(state));
    }
    resetNote();
    textController.clear();
  }

  void resetNote() {
    state = NoteModel();
  }

  void updatePrivate(bool bool) {
    state = state.copyWith(isPrivate: bool);
  }

//   Future<int> _openAIsSentimentAnalysis() async {
//     OpenAICompletionModel apiResult = await OpenAI.instance.completion.create(
//       model: 'text-davinci-003',
//       prompt: '''
// Evaluate the sentiment the following text as ${sentimentValues.join(', ')} for
// ${sentimentLabels.join(', ')} respectively. Please return the sentiment after the
// `Value: ` keyword.

// Text:```${state.content}```

// Value: ''',
//       temperature: 0,
//       maxTokens: 60,
//       topP: 1,
//       frequencyPenalty: 0.5,
//       presencePenalty: 0,
//       n: 1,
//       stop: 'Label:',
//       echo: true,
//     );
//     String response = apiResult.choices.first.text;
//     String result = response.split('Value: ').last.trim();
//     int sentiment = int.parse(result);
//     return sentiment;
//   }

  // void _updateOpenAIsSentimentAnalysis(int sentiment) async {
  //   state = state.copyWith(sentiment: sentiment);
  // }

  // Future<void> updateSentimentAndSaveNote() async {
  //   _updateOpenAIsSentimentAnalysis(await _openAIsSentimentAnalysis());
  //   await FirestoreService.saveNote(state);
  // }

  // static Future<void> updateAllUserNotes() async {
  //   log(
  //     'Updating all user notes',
  //     name: 'WritingController:updateAllUserNotes()',
  //   );
  //   QuerySnapshot<Map<String, dynamic>> collection =
  //       await FirestoreService.writingCollectionReference()
  //           .where('isPrivate', isEqualTo: false)
  //           .get();
  //   for (QueryDocumentSnapshot<Map<String, dynamic>> element
  //       in collection.docs) {
  //     // await _sentimentAnalysis(element);
  //     // await removeSentimentFromDocument(element);
  //   }
  //   // for (int index = 0; index < 1; index++) {
  //   //   // for (int i = 0; i < collection.docs.length; i++) {
  //   //   await _sentimentAnalysis(collection.docs.reversed.elementAt(index));
  //   //   // await removeSentimentFromDocument(element);
  //   // }
  // }

  // Future<void> addOpenAIsSentimentAnalysisToDocument(
  //   QueryDocumentSnapshot<Map<String, dynamic>> element,
  // ) async {
  //   if (!element.data().containsKey('sentiment')) {
  //     state = NoteModel.fromDocument(element.data());
  //     // _updateOpenAIsSentimentAnalysis(await _openAIsSentimentAnalysis());
  //     await FirestoreService.writingCollectionReference()
  //         .doc(state.timestamp.toString())
  //         .update(state.toDocument());
  //   }
  // }

  void updateSentimentAnalysis(AnalyzeSentimentResponse response) {
    // state = state.copyWith(
    //   sentimentScore: response.documentSentiment?.score,
    //   sentimentMagnitude: response.documentSentiment?.magnitude,
    //   sentenceCount: response.sentences?.length,
    //   sentiment: calculateSentiment(
    //     response.documentSentiment?.score,
    //     response.documentSentiment?.magnitude,
    //   ),
    // );
  }
}
