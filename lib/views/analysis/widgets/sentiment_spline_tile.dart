import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../controllers/analysis_view_controller.dart';
import '../../../extensions/int_extensions.dart';
import '../../../models/analysis/analysis_model.dart';
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
  @override
  Widget build(BuildContext context) {
    int sentimentDataLength = AnalysisViewController.analysisModelList.length;
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
    List<AnalysisModel> sentimentData =
        AnalysisViewController.analysisModelList.sublist(
      sentimentDataLength - periodRangeValues[selectedPeriodRange.first]!,
    );
    final chartData = <ChartData>[
      for (int i = 0; i < sentimentData.length; i++)
        ChartData(
          sentimentData[i].timestamp.timestampToDateTime(),
          sentimentData[i].sentiment!,
        ),
    ];
    return CustomListTile(
      contentPadding: EdgeInsets.all(gap),
      titleString: 'Sentiment Line',
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
                minimum: sentimentValues.min.toDouble(),
                maximum: sentimentValues.max.toDouble(),
                interval: 1,
                isVisible: true,
              ),
              primaryXAxis: DateTimeCategoryAxis(
                dateFormat: DateFormat.yMMMd(),
                interval: 7,
                isVisible: true,
                labelRotation: -45,
                labelAlignment: LabelAlignment.center,
              ),
              series: <ChartSeries<ChartData, DateTime>>[
                // Renders spline chart
                SplineSeries<ChartData, DateTime>(
                  color: theme.colorScheme.primary,
                  dataSource: chartData,
                  splineType: SplineType.natural,
                  cardinalSplineTension: 0.9,
                  xValueMapper: (ChartData data, _) => data.x,
                  yValueMapper: (ChartData data, _) => data.y,
                  animationDuration: 1000,
                  trendlines: <Trendline>[
                    Trendline(
                      animationDuration: 1000,
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
          const TextDivider('Time Period'),
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
