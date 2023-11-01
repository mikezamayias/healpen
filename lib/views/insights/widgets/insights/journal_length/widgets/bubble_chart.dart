import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../../../../controllers/analysis_view_controller.dart';
import '../../../../../../extensions/analysis_model_extensions.dart';
import '../../../../../../extensions/int_extensions.dart';
import '../../../../../../extensions/stream_extensions.dart';
import '../../../../../../models/analysis/analysis_model.dart';
import '../../../../../../models/note/note_model.dart';
import '../../../../../../route_controller.dart';
import '../../../../../../services/firestore_service.dart';
import '../../../../../../utils/constants.dart';
import '../../../../../../utils/helper_functions.dart';

class BubbleChart extends ConsumerWidget {
  const BubbleChart({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<AnalysisModel> analysisModelList =
        ref.watch(AnalysisViewController.analysisModelListProvider);
    final monthSet = analysisModelList.getMonthsFromAnalysisModelList();
    return SfCartesianChart(
      primaryXAxis: DateTimeCategoryAxis(
        dateFormat: DateFormat('MMM dd'),
        isVisible: true,
        name: 'Date',
        interval: monthSet.length.toDouble(),
        majorGridLines: const MajorGridLines(width: 0),
        minorGridLines: const MinorGridLines(width: 0),
        majorTickLines: const MajorTickLines(width: 0),
        minorTickLines: const MinorTickLines(width: 0),
        edgeLabelPlacement: EdgeLabelPlacement.shift,
        rangePadding: ChartRangePadding.none,
      ),
      primaryYAxis: DateTimeCategoryAxis(
        dateFormat: DateFormat('mm:ss'),
        isVisible: true,
        name: 'Duration',
        intervalType: DateTimeIntervalType.minutes,
        interval: 1,
        majorGridLines: const MajorGridLines(width: 0),
        minorGridLines: const MinorGridLines(width: 0),
        majorTickLines: const MajorTickLines(width: 0),
        minorTickLines: const MinorTickLines(width: 0),
        rangePadding: ChartRangePadding.none,
        edgeLabelPlacement: EdgeLabelPlacement.shift,
      ),
      series: <CartesianSeries>[
        BubbleSeries<AnalysisModel, DateTime>(
          dataSource: analysisModelList,
          xValueMapper: (AnalysisModel data, _) =>
              data.timestamp.timestampToDateTime(),
          yValueMapper: (AnalysisModel data, _) => data.duration,
          sizeValueMapper: (AnalysisModel data, _) => data.duration,
          pointColorMapper: (AnalysisModel data, _) => getShapeColorOnSentiment(
            context,
            data.score,
          ),
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
            FirestoreService()
                .getNoteAndAnalysis(analysisModelList
                    .elementAt(pointInteractionDetails.pointIndex!)
                    .timestamp)
                .toFuture<({AnalysisModel? analysis, NoteModel note})>()
                .then((({AnalysisModel? analysis, NoteModel note}) data) {
              context.navigator.pushNamed(
                RouterController.noteViewRoute.route,
                arguments: (
                  noteModel: data.note,
                  analysisModel: data.analysis,
                ),
              );
            });
          },
        ),
      ],
    );
  }
}