import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/analysis/analysis_model.dart';

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
  static final analysisModelListProvider = StateProvider(
    (ref) => <AnalysisModel>[],
  );
}
