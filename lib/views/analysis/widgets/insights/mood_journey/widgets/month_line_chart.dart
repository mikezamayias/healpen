import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../../../../extensions/date_time_extensions.dart';
import '../../../../../../extensions/int_extensions.dart';
import '../../../../../../models/analysis/analysis_model.dart';
import '../../../../../../route_controller.dart';
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
        final analysisModelList = snapshot.data!.docs
            .map((QueryDocumentSnapshot<AnalysisModel> analysisModel) =>
                analysisModel.data())
            .toList();
        final List<ChartData> chartData = analysisModelList
            .map((AnalysisModel analysisModel) => ChartData(
                  analysisModel.timestamp.timestampToDateTime(),
                  analysisModel.sentiment!,
                ))
            .toList();
        return SfCartesianChart(
          plotAreaBorderWidth: 0,
          primaryYAxis: NumericAxis(
            interval: 5,
            isVisible: true,
            opposedPosition: false,
            name: 'Sentiment',
            minimum: sentimentValues.min.toDouble(),
            maximum: sentimentValues.max.toDouble(),
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
                  width: gap,
                  color: context.theme.colorScheme.primary,
                  opacity: 0.2,
                ),
              ],
              dataLabelSettings: const DataLabelSettings(
                isVisible: false,
              ),
              onPointDoubleTap: (pointInteractionDetails) async {
                log(pointInteractionDetails.viewportPointIndex.toString());
                log(
                  analysisModelList
                      .elementAt(
                          pointInteractionDetails.viewportPointIndex!.toInt())
                      .toString(),
                );
                final analysisModel = analysisModelList.elementAt(
                    pointInteractionDetails.viewportPointIndex!.toInt());
                final noteModel =
                    (await FirestoreService().getNote(analysisModel.timestamp))
                        .data()!;
                if (context.mounted) {
                  context.navigator.pushNamed(
                    RouterController.noteViewRoute.route,
                    arguments: (
                      noteModel: noteModel,
                      analysisModel: analysisModel,
                    ),
                  );
                }
              },
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
