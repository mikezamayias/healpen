import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/analysis/analysis_model.dart';

enum AnalysisProgress {
  removingPreviousAnalysis,
  analyzingNotes,
  completed,
}

final analysisModelListProvider =
    StateNotifierProvider<AnalysisModelList, Set<AnalysisModel>>(
  (ref) => AnalysisModelList(),
);

class AnalysisModelList extends StateNotifier<Set<AnalysisModel>> {
  AnalysisModelList() : super(<AnalysisModel>{});

  void addAll(Set<AnalysisModel> models) {
    state = {...state, ...models};
  }
}
