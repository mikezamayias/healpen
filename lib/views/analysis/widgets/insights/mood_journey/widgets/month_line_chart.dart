import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../../../../extensions/date_time_extensions.dart';
import '../../../../../../extensions/int_extensions.dart';
import '../../../../../../models/analysis/analysis_model.dart';
import '../../../../../../services/firestore_service.dart';
import '../../../../../../utils/constants.dart';
import '../../../../../../widgets/custom_list_tile.dart';

class MonthLineChart extends StatelessWidget {
  const MonthLineChart({
    super.key,
    required this.month,
  });

  final DateTime month;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<AnalysisModel>>(
      stream: FirestoreService().getAnalysisBetweenDates(
        month.startOfMonth(),
        month.endOfMonth(),
      ),
      builder: (
        context,
        AsyncSnapshot<QuerySnapshot<AnalysisModel>> snapshot,
      ) {
        if (!(snapshot.connectionState == ConnectionState.active)) {
          return const CustomListTile(
            titleString: 'Loading...',
          );
        }
        log(
          '${month.startOfMonth()}',
          name: 'start Month',
        );
        log(
          '${month.endOfMonth()}',
          name: 'end Month',
        );
        log('${snapshot.data!.docs}', name: 'snapshot data');
        final List<ChartData> chartData = snapshot.data!.docs
            .map((QueryDocumentSnapshot<AnalysisModel> analysisModel) =>
                ChartData(
                  analysisModel.data().timestamp.timestampToDateTime(),
                  analysisModel.data().sentiment!,
                ))
            .toList();
        return SfCartesianChart(
          plotAreaBorderWidth: 0,
          primaryYAxis: NumericAxis(
            interval: 0.2,
            isVisible: false,
            opposedPosition: false,
            name: 'Sentiment',
          ),
          primaryXAxis: DateTimeCategoryAxis(
            dateFormat: DateFormat('MMM dd'),
            isVisible: true,
            name: 'Date',
            interval: 1,
            labelRotation: 45,
            majorGridLines: const MajorGridLines(width: 0),
            minorGridLines: const MinorGridLines(width: 0),
            majorTickLines: const MajorTickLines(width: 0),
            minorTickLines: const MinorTickLines(width: 0),
            edgeLabelPlacement: EdgeLabelPlacement.shift,
          ),
          series: [
            // Renders spline chart
            ScatterSeries(
              dataSource: chartData,
              xValueMapper: (ChartData data, _) => data.x,
              yValueMapper: (ChartData data, _) => data.y,
              sortFieldValueMapper: (ChartData data, _) => data.x,
              color: context.theme.colorScheme.primary,
              enableTooltip: true,
              sortingOrder: SortingOrder.ascending,
              animationDuration: standardDuration.inSeconds.toDouble(),
              trendlines: <Trendline>[
                Trendline(
                  animationDuration: standardDuration.inSeconds.toDouble(),
                  type: TrendlineType.polynomial,
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
    );
  }
}

class ChartData {
  ChartData(this.x, this.y);
  final DateTime x;
  final double y;
}
