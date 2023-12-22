import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../../../../controllers/analysis_view_controller.dart';
import '../../../../../../extensions/analysis_model_extensions.dart';
import '../../../../../../extensions/chart_data_extensions.dart';
import '../../../../../../models/analysis/analysis_model.dart';
import '../../../../../../models/analysis/chart_data_model.dart';
import '../../../../../../utils/constants.dart';
import '../../../../../../utils/helper_functions.dart';
import '../../../../../../utils/show_healpen_dialog.dart';
import '../../../../../history/widgets/calendar_tile/widgets/date_dialog.dart';

class WeekLineChart extends ConsumerWidget {
  const WeekLineChart(
    this.week, {
    super.key,
  });

  final DateTime week;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DateTime start = week;
    final DateTime end = start.subtract(7.days);
    final Set<AnalysisModel> dateAnalysisModelList =
        ref.watch(analysisModelSetProvider).getAnalysisBetweenDates(
              start: end,
              end: start,
            );
    final List<ChartData> chartData = dateAnalysisModelList
        .averageDaysSentimentToChartData()
        .insertNullValuesBetween(
          start: end,
          end: start,
        );
    return SfCartesianChart(
      margin: EdgeInsets.zero,
      plotAreaBorderWidth: 0,
      primaryYAxis: NumericAxis(
        isVisible: true,
        opposedPosition: false,
        name: 'Sentiment',
        minimum: sentimentValues.min.toDouble(),
        maximum: sentimentValues.max.toDouble(),
        rangePadding: ChartRangePadding.none,
      ),
      primaryXAxis: DateTimeCategoryAxis(
        dateFormat: DateFormat('MMM\nEEE\ndd'),
        isVisible: true,
        name: 'Date',
        interval: 1,
        majorGridLines: const MajorGridLines(width: 0),
        minorGridLines: const MinorGridLines(width: 0),
        rangePadding: ChartRangePadding.none,
        majorTickLines: const MajorTickLines(width: 0),
        minorTickLines: const MinorTickLines(width: 0),
        edgeLabelPlacement: EdgeLabelPlacement.shift,
      ),
      series: [
        // Renders spline chart
        ScatterSeries(
          markerSettings: MarkerSettings(
            width: gap,
            height: gap,
          ),
          dataSource: chartData,
          xValueMapper: (data, _) => data.x,
          yValueMapper: (data, _) => data.y,
          sortFieldValueMapper: (data, _) => data.x,
          pointColorMapper: (ChartData data, _) => data.y != null
              ? getShapeColorOnSentiment(
                  context.theme,
                  data.y,
                )
              : null,
          enableTooltip: true,
          sortingOrder: SortingOrder.ascending,
          animationDuration: standardDuration.inSeconds.toDouble(),
          trendlines: <Trendline>[
            Trendline(
              animationDuration: standardDuration.inSeconds.toDouble(),
              type: TrendlineType.polynomial,
              width: gap,
              color: context.theme.colorScheme.outlineVariant,
              opacity: 0.2,
            ),
          ],
          onPointDoubleTap: (ChartPointDetails pointInteractionDetails) {
            final date =
                chartData.elementAt(pointInteractionDetails.pointIndex!).x;
            showHealpenDialog(
              context: context,
              customDialog: DateDialog(date: date),
            );
          },
        )
      ],
    );
  }
}
