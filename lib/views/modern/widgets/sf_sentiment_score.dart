import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../controllers/analysis_view_controller.dart';
import '../../../extensions/analysis_model_extensions.dart';
import '../../../extensions/date_time_extensions.dart';
import '../../../models/analysis/chart_data_model.dart';
import '../../../utils/constants.dart';
import '../../../utils/helper_functions.dart';
import '../../../utils/show_healpen_dialog.dart';
import '../../history/widgets/calendar_tile/widgets/date_dialog.dart';

class SfSentimentScore extends ConsumerWidget {
  const SfSentimentScore({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shapeColorOnSentiment = getShapeColorOnSentiment(
      context.theme,
      ref.read(analysisModelSetProvider.notifier).averageScore,
    );
    return SfCartesianChart(
      margin: EdgeInsets.zero,
      plotAreaBorderWidth: 0,
      primaryXAxis: CategoryAxis(
        isVisible: false,
        rangePadding: ChartRangePadding.none,
        majorGridLines: const MajorGridLines(width: 0),
        labelStyle: TextStyle(
          color: shapeColorOnSentiment,
          fontSize: 12.sp,
        ),
      ),
      primaryYAxis: NumericAxis(
        isVisible: false,
        rangePadding: ChartRangePadding.none,
        minimum: sentimentValues.min,
        maximum: sentimentValues.max,
        interval: 0.5,
        majorGridLines: const MajorGridLines(width: 0),
        labelStyle: context.theme.textTheme.titleSmall!.copyWith(
          color: shapeColorOnSentiment,
        ),
      ),
      series: <ChartSeries>[
        SplineSeries<ChartData, String>(
          width: gap / 2,
          dataSource: ref
              .read(analysisModelSetProvider)
              .averageDaysSentimentToChartData(),
          xValueMapper: (ChartData chartData, _) => chartData.x.toEEEEMMMd(),
          yValueMapper: (ChartData chartData, _) => chartData.y,
          color: shapeColorOnSentiment,
          dataLabelSettings: DataLabelSettings(
            isVisible: false,
            labelAlignment: ChartDataLabelAlignment.top,
            textStyle: TextStyle(
              color: shapeColorOnSentiment,
              fontSize: 12.sp,
            ),
          ),
          onPointDoubleTap: (ChartPointDetails pointInteractionDetails) {
            final date = ref
                .read(analysisModelSetProvider)
                .averageDaysSentimentToChartData()
                .elementAt(pointInteractionDetails.pointIndex!)
                .x;
            showHealpenDialog(
              context: context,
              customDialog: DateDialog(date: date),
            );
          },
        ),
      ],
    );
  }
}
