import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/analysis/analysis_model.dart';

enum AnalysisProgress {
  removingPreviousAnalysis,
  analyzingNotes,
  completed,
}

final analysisModelListProvider = StateProvider<List<AnalysisModel>>(
  (ref) => <AnalysisModel>[],
);
