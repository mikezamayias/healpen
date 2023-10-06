import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../controllers/analysis_view_controller.dart';
import '../../../extensions/int_extensions.dart';
import '../../../utils/constants.dart';
import '../../../widgets/custom_list_tile.dart';
import '../../../widgets/text_divider.dart';

class SplineSentimentTile extends ConsumerStatefulWidget {
  const SplineSentimentTile({
    super.key,
  });

  @override
  ConsumerState<SplineSentimentTile> createState() =>
      _SplineSentimentTileState();
}

class _SplineSentimentTileState extends ConsumerState<SplineSentimentTile> {
  Set<int> selectedPeriodRange = {0};
  final animationDuration = 0;
  @override
  Widget build(BuildContext context) {
    final sentimentData =
        ref.watch(AnalysisViewController.analysisModelListProvider);
    final sentimentDataLength = sentimentData.length;
    Map<int, String> periodRanges = {
      0: 'all time',
      1: 'last week',
      2: 'last month',
      3: 'last 3 months',
      4: 'last 6 months',
      5: 'last 1 year',
    };
    Map<int, int> periodRangeValues = {
      0: sentimentDataLength,
      1: 7,
      2: 30,
      3: 90,
      4: 180,
      5: 365,
    };
    final chartData = <ChartData>[
      for (int i = 0; i < sentimentData.length; i++)
        ChartData(
          sentimentData[i].timestamp.timestampToDateTime(),
          sentimentData[i].sentiment!,
        ),
    ];
    return CustomListTile(
      contentPadding: EdgeInsets.all(gap),
      titleString: 'Sentiment Curve',
      enableSubtitleWrapper: false,
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: EdgeInsets.all(gap),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(radius - gap),
            ),
            child: SfCartesianChart(
              primaryYAxis: NumericAxis(
                interval: 1,
                isVisible: true,
                opposedPosition: false,
                name: 'Sentiment',
              ),
              primaryXAxis: DateTimeCategoryAxis(
                dateFormat: DateFormat('MMM dd\nyyyy'),
                isVisible: true,
                name: 'Date',
              ),
              series: <ChartSeries<ChartData, DateTime>>[
                // Renders spline chart
                SplineSeries<ChartData, DateTime>(
                  color: theme.colorScheme.primary,
                  dataSource: chartData.sublist(
                    sentimentDataLength -
                        periodRangeValues[selectedPeriodRange.first]!,
                  ),
                  enableTooltip: true,
                  sortingOrder: SortingOrder.ascending,
                  sortFieldValueMapper: (ChartData data, _) => data.x,
                  splineType: SplineType.natural,
                  cardinalSplineTension: 0.9,
                  xValueMapper: (ChartData data, _) => data.x,
                  yValueMapper: (ChartData data, _) => data.y,
                  animationDuration: animationDuration.toDouble(),
                  trendlines: <Trendline>[
                    Trendline(
                      animationDuration: animationDuration.toDouble(),
                      type: TrendlineType.polynomial,
                      polynomialOrder: 6,
                      width: 3,
                      color: theme.colorScheme.primary,
                      opacity: 0.2,
                      dashArray: <double>[0, 0],
                    ),
                  ],
                )
              ],
            ),
          ),
          SizedBox(height: gap),
          const TextDivider('Time Range'),
          SizedBox(height: gap),
          SegmentedButton<int>(
            segments: [
              for (int i = 0; i < periodRanges.length; i++)
                if (sentimentDataLength >= periodRangeValues[i]!)
                  ButtonSegment(
                    value: i,
                    label: Text(periodRanges[i]!),
                  ),
            ],
            selected: selectedPeriodRange,
            showSelectedIcon: false,
            onSelectionChanged: (Set<int> p0) {
              setState(() {
                selectedPeriodRange = p0;
              });
            },
          ),
        ],
      ),
    );
  }
}

class ChartData {
  ChartData(this.x, this.y);
  final DateTime x;
  final double y;
}
