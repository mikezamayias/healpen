import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../controllers/analysis_view_controller.dart';
import '../../../../../extensions/analysis_model_extensions.dart';
import '../../../../../models/analysis/analysis_model.dart';
import '../../../../../utils/constants.dart';
import '../../note_tile.dart';

class DateDialog extends ConsumerWidget {
  const DateDialog({
    super.key,
    required this.startDate,
    required this.endDate,
  });

  final DateTime startDate;
  final DateTime endDate;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<AnalysisModel> analysisModelList = ref
        .watch(analysisModelListProvider)
        .getAnalysisBetweenDates(start: startDate, end: endDate);
    return SingleChildScrollView(
      child: ListView.separated(
        padding: EdgeInsets.all(gap),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        separatorBuilder: (_, __) => SizedBox(height: gap),
        itemCount: analysisModelList.length,
        itemBuilder: (context, index) => NoteTile(
          timestamp: analysisModelList[index].timestamp,
        ),
      ),
    );
  }
}
