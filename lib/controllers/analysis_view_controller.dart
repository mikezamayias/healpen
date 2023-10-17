import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/analysis/analysis_model.dart';
import '../providers/settings_providers.dart';

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
  static final analysisModelListProvider = StateProvider<List<AnalysisModel>>(
    (ref) => <AnalysisModel>[],
  );

  static late double overallSentiment;

  static final goodColorProvider = StateProvider<Color>(
    (ref) => ref.watch(themeProvider).colorScheme.primary,
  );

  static final badColorProvider = StateProvider<Color>(
    (ref) => ref.watch(themeProvider).colorScheme.error,
  );

  static final onGoodColorProvider = StateProvider<Color>(
    (ref) => ref.watch(themeProvider).colorScheme.onPrimary,
  );

  static final onBadColorProvider = StateProvider<Color>(
    (ref) => ref.watch(themeProvider).colorScheme.onError,
  );
}
