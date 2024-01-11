import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'analysis/analysis_model.dart';

class NoteTileModel {
  final isSelectedProvider = StateProvider<bool>((ref) => false);
  AnalysisModel analysisModel;

  NoteTileModel(this.analysisModel);
}
