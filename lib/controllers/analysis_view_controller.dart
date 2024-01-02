import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../extensions/analysis_model_extensions.dart';
import '../models/analysis/analysis_model.dart';

enum AnalysisProgress {
  removingPreviousAnalysis,
  analyzingNotes,
  completed,
}

final analysisModelSetProvider =
    StateNotifierProvider<AnalysisModelList, Set<AnalysisModel>>(
  (ref) => AnalysisModelList(),
);

class AnalysisModelList extends StateNotifier<Set<AnalysisModel>> {
  AnalysisModelList() : super(<AnalysisModel>{});

  void addAll(Set<AnalysisModel> models) {
    state = {...state, ...models};
  }

  Set<AnalysisModel> get analysisModels => state;

  double get averageScore => analysisModels.averageScore();
}
