import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../../../../extensions/date_time_extensions.dart';
import '../../../../../../extensions/int_extensions.dart';
import '../../../../../../models/analysis/analysis_model.dart';
import '../../../../../../services/firestore_service.dart';
import '../../../../../../utils/constants.dart';
import '../../../../../../widgets/custom_list_tile.dart';
import '../../../../../../widgets/text_divider.dart';

class MonthLineChart extends StatelessWidget {
  const MonthLineChart({
    super.key,
    required this.month,
  });

  final DateTime month;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: gap),
      child: SizedBox(
        height: 30.h,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextDivider(
              DateFormat('y, MMMM').format(month),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: gap),
                child: StreamBuilder<QuerySnapshot<AnalysisModel>>(
                  stream: FirestoreService().getAnalysisBetweenDates(
                    month.startOfMonth(),
                    month.endOfMonth(),
                  ),
                  builder: (
                    context,
                    AsyncSnapshot<QuerySnapshot<AnalysisModel>> snapshot,
                  ) {
                    log(
                      '${month.startOfMonth()}',
                      name: 'start Month',
                    );
                    log(
                      '${month.endOfMonth()}',
                      name: 'end Month',
                    );
                    log('${snapshot.data?.docs}', name: 'snapshot data');
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const CustomListTile(
                        titleString: 'No data available',
                      );
                    }
                    List<AnalysisModel> monthSentimentData = snapshot.data!.docs
                        .map(
                          (QueryDocumentSnapshot<AnalysisModel> element) =>
                              element.data(),
                        )
                        .toList();
                    final chartData = <ChartData>[
                      for (int i = 0; i < monthSentimentData.length; i++)
                        ChartData(
                          monthSentimentData[i].timestamp.timestampToDateTime(),
                          monthSentimentData[i].sentiment!,
                        ),
                    ];
                    return SfCartesianChart(
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
                          color: context.theme.colorScheme.primary,
                          dataSource: chartData,
                          enableTooltip: true,
                          sortingOrder: SortingOrder.ascending,
                          sortFieldValueMapper: (ChartData data, _) => data.x,
                          splineType: SplineType.natural,
                          cardinalSplineTension: 0.9,
                          xValueMapper: (ChartData data, _) => data.x,
                          yValueMapper: (ChartData data, _) => data.y,
                          animationDuration:
                              standardDuration.inSeconds.toDouble(),
                          trendlines: <Trendline>[
                            Trendline(
                              animationDuration:
                                  standardDuration.inSeconds.toDouble(),
                              type: TrendlineType.polynomial,
                              polynomialOrder: 6,
                              width: 3,
                              color: context.theme.colorScheme.primary,
                              opacity: 0.2,
                              dashArray: <double>[0, 0],
                            ),
                          ],
                        )
                      ],
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ChartData {
  ChartData(this.x, this.y);
  final DateTime x;
  final double y;
}
