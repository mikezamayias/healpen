import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:graphic/graphic.dart';

import '../../../controllers/analysis_view_controller.dart';
import '../../../extensions/analysis_model_extensions.dart';
import '../../../extensions/date_time_extensions.dart';
import '../../../models/analysis/chart_data_model.dart';
import '../../../utils/constants.dart';
import '../../../utils/helper_functions.dart';

class GraphicSentimentScore extends ConsumerWidget {
  const GraphicSentimentScore({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<ChartData> chartData =
        ref.watch(analysisModelSetProvider).averageDaysSentimentToChartData();
    final Color shapeColorOnSentiment = getShapeColorOnSentiment(
      context.theme,
      ref.watch(analysisModelSetProvider.notifier).averageScore,
    );
    return Chart(
      padding: (Size size) => EdgeInsets.zero,
      data: chartData,
      variables: <String, Variable<ChartData, dynamic>>{
        'x': Variable(
          accessor: (ChartData data) => data.x.toEEEEMMMd(),
        ),
        'y': Variable<ChartData, double>(
          accessor: (ChartData data) => data.y!,
        ),
      },
      marks: <Mark<Shape>>[
        LineMark(
          shape: ShapeEncode(value: BasicLineShape(smooth: true)),
          size: SizeEncode(value: gap / 2),
          color: ColorEncode(
            value: shapeColorOnSentiment,
          ),
        ),
      ],
    );
  }
}
