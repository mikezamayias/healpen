import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../controllers/analysis_view_controller.dart';
import '../../../extensions/int_extensions.dart';
import '../../../models/note/note_model.dart';
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
  Map<int, String> periodRanges = {
    0: 'week',
    1: 'month',
    2: '3 months',
    3: '6 months',
    4: '1 year',
  };
  Map<int, int> periodRangeValues = {
    0: 7,
    1: 30,
    2: 90,
    3: 180,
    4: 365,
  };
  Set<int> selectedPeriodRange = {0};
  @override
  Widget build(BuildContext context) {
    List<NoteModel> sentimentData = ref
        .watch(AnalysisViewController.noteModelsProviders.notifier)
        .state
        .reversed
        .toList()
        .getRange(0, periodRangeValues[selectedPeriodRange.first]!)
        .toList();
    final chartData = <ChartData>[
      for (int i = 0; i < sentimentData.length; i++)
        ChartData(
          sentimentData[i].timestamp.timestampToDateTime(),
          // sentimentData[i].sentiment!,
          sentimentData[i].timestamp,
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
                minimum: sentimentValues.min.toDouble() - 1,
                maximum: sentimentValues.max.toDouble() + 1,
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
                  color: theme.colorScheme.onPrimaryContainer,
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
                      dashArray: <double>[0, 0],
                    ),
                  ],
                )
              ],
            ),
          ),
          SizedBox(height: gap),
          const TextDivider('Last'),
          SizedBox(height: gap),
          SegmentedButton<int>(
            segments: [
              for (int i = 0; i < periodRanges.length; i++)
                if (ref
                        .watch(
                            AnalysisViewController.noteModelsProviders.notifier)
                        .state
                        .length >=
                    periodRangeValues[i]!)
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
  final int y;
}
