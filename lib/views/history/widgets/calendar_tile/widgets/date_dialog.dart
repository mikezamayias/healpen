import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:intl/intl.dart';

import '../../../../../controllers/analysis_view_controller.dart';
import '../../../../../extensions/analysis_model_extensions.dart';
import '../../../../../extensions/date_time_extensions.dart';
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
        ref.watch(analysisModelListProvider).getAnalysisBetweenDates(
              start: date.startOfDay(),
              end: date.endOfDay(),
            );
    final averageDayScore = analysisModelList.averageScore();
    final textColor = getTextColorOnSentiment(context.theme, averageDayScore);
    final List<Widget> noteTileList = analysisModelList
        .map((e) => NoteTile(
              analysisModel: e,
            ))
        .toList()
        .animate(
          interval: slightlyShortStandardDuration,
        )
        .fade(
          duration: standardDuration,
          curve: standardEasing,
        )
        .slideX(
          duration: standardDuration,
          curve: standardEasing,
          begin: -0.6,
          end: 0,
        );
    return CustomDialog(
      titleString: DateFormat('EEE d MMM yyyy').format(date),
      trailingWidget: Text(
        averageDayScore.toStringAsFixed(2),
        style: context.theme.textTheme.headlineSmall!.copyWith(
          color: textColor,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.start,
      ),
      enableContentContainer: false,
      contentWidget: SingleChildScrollView(
        child: ListView.separated(
          padding: EdgeInsets.all(gap),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          separatorBuilder: (_, __) => SizedBox(height: gap),
          itemCount: noteTileList.length,
          itemBuilder: (context, index) => noteTileList.elementAt(index),
        ),
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
    );
  }
}
