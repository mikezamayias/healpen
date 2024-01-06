import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';

import '../../../../../controllers/analysis_view_controller.dart';
import '../../../../../extensions/analysis_model_extensions.dart';
import '../../../../../extensions/date_time_extensions.dart';
import '../../../../../extensions/double_extensions.dart';
import '../../../../../utils/constants.dart';
import '../../../../../utils/helper_functions.dart';
import '../../../../../widgets/custom_dialog.dart';
import '../../../../../widgets/custom_list_tile.dart';
import '../../note_tile.dart';

class DateDialog extends ConsumerWidget {
  const DateDialog({
    super.key,
    required this.date,
  });

  final DateTime date;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analysisModelList =
        ref.watch(analysisModelSetProvider).getAnalysisBetweenDates(
              start: date.startOfDay(),
              end: date.endOfDay(),
            );
    final dayAverageScore = analysisModelList.averageScore();
    final textColor = getShapeColorOnSentiment(context.theme, dayAverageScore);
    final List<Widget> noteTileList = analysisModelList
        .map((e) => NoteTile(analysisModel: e))
        .toList()
        .animate(interval: slightlyShortStandardDuration)
        .fade(
          duration: standardDuration,
          curve: standardCurve,
        )
        .slideX(
          duration: standardDuration,
          curve: standardCurve,
          begin: -0.6,
          end: 0,
        );
    final dialogTitle =
        '${date.toEEEEMMMd()} - ${sentimentLabels.elementAt(getClosestSentimentIndex(dayAverageScore.withDecimalPlaces(2)))}';
    return CustomDialog(
      titleString: dialogTitle,
      enableContentContainer: false,
      contentWidget: ClipRRect(
        borderRadius: BorderRadius.circular(radius - gap),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: gap),
          child: SingleChildScrollView(
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: gap),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              separatorBuilder: (_, __) => SizedBox(height: gap),
              itemCount: noteTileList.length,
              itemBuilder: (context, index) => noteTileList.elementAt(index),
            ),
          ),
        ),
      ),
      actions: [
        CustomListTile(
          useSmallerNavigationSetting: false,
          responsiveWidth: true,
          titleString: 'Close',
          cornerRadius: radius - gap,
          onTap: () {
            context.navigator.pop();
          },
        )
      ],
    );
  }
}
