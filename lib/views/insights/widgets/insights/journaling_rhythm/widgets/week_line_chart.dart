import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../../../../controllers/analysis_view_controller.dart';
import '../../../../../../extensions/analysis_model_extensions.dart';
import '../../../../../../models/analysis/chart_data_model.dart';
import '../../../../../../providers/settings_providers.dart';
import '../../../../../../utils/constants.dart';
import '../../../../../../utils/helper_functions.dart';
import '../../../../../../utils/show_healpen_dialog.dart';
import '../../../../../../widgets/custom_dialog.dart';
import '../../../../../../widgets/custom_list_tile.dart';
import '../../../../../history/widgets/calendar_tile/widgets/date_dialog.dart';

class WeekLineChart extends ConsumerWidget {
  const WeekLineChart(
    this.week, {
    super.key,
  });

  final List<DateTime> week;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<ChartData> actualData = ref
        .watch(AnalysisViewController.analysisModelListProvider)
        .getAnalysisBetweenDates(start: week.first, end: week.last)
        .averageDaysSentimentToChartData();
    final List<ChartData> weekData = initializeWeekData(actualData);
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
        interval: 1,
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
          dataSource: weekData,
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
                weekData.elementAt(pointInteractionDetails.pointIndex!).x;
            showHealpenDialog(
              context: context,
              doVibrate: ref.watch(navigationEnableHapticFeedbackProvider),
              customDialog: CustomDialog(
                titleString: DateFormat('EEE d MMM yyyy').format(date),
                enableContentContainer: false,
                contentWidget: DateDialog(
                  date: date,
                ),
                actions: [
                  CustomListTile(
                    useSmallerNavigationSetting: false,
                    responsiveWidth: true,
                    titleString: 'Close',
                    cornerRadius: radius - gap,
                    onTap: () {
                      Navigator.pop(navigatorKey.currentContext!);
                    },
                  )
                ],
              ),
            );
          },
        )
      ],
    );
  }

  /// Initializes the week data for the line chart.
  ///
  /// Given a list of [actualData], this method maps each day in the [week] list to the corresponding data in [actualData].
  /// If there is no data available for a specific day, a [ChartData] object with a null value is created.
  /// The resulting list of [ChartData] objects is returned.
  List<ChartData> initializeWeekData(List<ChartData> actualData) {
    return week.map((DateTime dayInWeek) {
      return actualData.firstWhere(
        (ChartData chartData) =>
            DateFormat('yyyy-MM-dd').format(chartData.x) ==
            DateFormat('yyyy-MM-dd').format(dayInWeek),
        orElse: () => ChartData(dayInWeek, null),
      );
    }).toList();
  }
}
