import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../../../../extensions/analysis_model_extensions.dart';
import '../../../../../../models/analysis/analysis_model.dart';
import '../../../../../../models/analysis/chart_data_model.dart';
import '../../../../../../providers/settings_providers.dart';
import '../../../../../../services/firestore_service.dart';
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
    return StreamBuilder<QuerySnapshot<AnalysisModel>>(
      stream: FirestoreService().getAnalysisBetweenDates(week.first, week.last),
      builder: (
        BuildContext context,
        AsyncSnapshot<QuerySnapshot<AnalysisModel>> snapshot,
      ) {
        if (!(snapshot.connectionState == ConnectionState.active)) {
          return const CustomListTile(
            titleString: 'Loading...',
          );
        }
        final List<ChartData> actualData = snapshot.data!.docs
            .map((QueryDocumentSnapshot<AnalysisModel> analysisModel) =>
                analysisModel.data())
            .toList()
            .averageDaysSentimentToChartData();
        final List<ChartData> weekData = initializeWeekData(actualData);
        return SfCartesianChart(
          margin: EdgeInsets.only(top: gap),
          plotAreaBorderWidth: 0,
          primaryYAxis: NumericAxis(
            isVisible: true,
            opposedPosition: false,
            name: 'Sentiment',
            minimum: sentimentValues.min.toDouble(),
            maximum: sentimentValues.max.toDouble(),
            interval: 1,
          ),
          primaryXAxis: DateTimeCategoryAxis(
            dateFormat: DateFormat('EEE dd'),
            isVisible: true,
            name: 'Date',
            interval: 1,
            labelRotation: -45,
            majorGridLines: const MajorGridLines(width: 0),
            minorGridLines: const MinorGridLines(width: 0),
            majorTickLines: const MajorTickLines(width: 0),
            minorTickLines: const MinorTickLines(width: 0),
            edgeLabelPlacement: EdgeLabelPlacement.shift,
          ),
          tooltipBehavior: TooltipBehavior(
            activationMode: ActivationMode.singleTap,
            enable: true,
            shouldAlwaysShow: false,
            animationDuration: standardDuration.inMilliseconds,
            tooltipPosition: TooltipPosition.pointer,
            color: context.theme.colorScheme.surface,
            shadowColor: context.theme.colorScheme.onSurface,
            builder: (data, point, series, pointIndex, seriesIndex) {
              return Container(
                padding: EdgeInsets.all(gap),
                decoration: BoxDecoration(
                  color: getShapeColorOnSentiment(
                    context,
                    double.parse('${point.y}'),
                  ),
                  borderRadius: BorderRadius.circular(radius),
                ),
                child: Text(
                  '${point.y}',
                  style: context.theme.textTheme.bodyMedium!.copyWith(
                    color: getTextColorOnSentiment(
                      context,
                      double.parse('${point.y}'),
                    ),
                  ),
                ),
              );
            },
          ),
          series: [
            // Renders spline chart
            ScatterSeries(
              dataSource: weekData,
              xValueMapper: (data, _) => data.x,
              yValueMapper: (data, _) => data.y,
              sortFieldValueMapper: (data, _) => data.x,
              color: context.theme.colorScheme.primary,
              enableTooltip: true,
              sortingOrder: SortingOrder.ascending,
              animationDuration: standardDuration.inSeconds.toDouble(),
              trendlines: <Trendline>[
                Trendline(
                  enableTooltip: false,
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
      },
    );
  }

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
