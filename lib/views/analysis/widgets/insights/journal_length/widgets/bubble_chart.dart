import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../../../../controllers/analysis_view_controller.dart';
import '../../../../../../extensions/analysis_model_extensions.dart';
import '../../../../../../models/analysis/chart_data_model.dart';
import '../../../../../../utils/constants.dart';
import '../../../../../../utils/helper_functions.dart';

class BubbleChart extends ConsumerWidget {
  const BubbleChart({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analysisModelList = ref
        .watch(AnalysisViewController.analysisModelListProvider)
        .toChartData();
    return SfCartesianChart(
      primaryXAxis: CategoryAxis(),
      primaryYAxis: CategoryAxis(isVisible: false),
      series: <CartesianSeries>[
        BubbleSeries<ChartData, String>(
          dataSource: analysisModelList,
          xValueMapper: (ChartData data, _) =>
              '${Random().nextDouble() * analysisModelList.length}',
          yValueMapper: (ChartData data, _) => data.y! * gap * 10,
          sizeValueMapper: (ChartData data, _) => data.y,
          pointColorMapper: (ChartData data, _) => data.y != null
              ? getShapeColorOnSentiment(
                  context,
                  data.y,
                )
              : null,
        )
      ],
    );
  }
}
