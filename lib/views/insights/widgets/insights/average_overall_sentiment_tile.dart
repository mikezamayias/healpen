import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import '../../../../controllers/analysis_view_controller.dart';
import '../../../../models/analysis/analysis_model.dart';
import '../../../../providers/settings_providers.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/helper_functions.dart';
import '../../../../utils/show_healpen_dialog.dart';
import '../../../../widgets/custom_dialog.dart';
import '../../../../widgets/custom_list_tile.dart';

class AverageOverallSentimentTile extends ConsumerWidget {
  const AverageOverallSentimentTile({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final labels = [
      'Very Unpleasant',
      'Unpleasant',
      'Slightly Unpleasant',
      'Neutral',
      'Slightly Pleasant',
      'Pleasant',
      'Very Pleasant'
    ];
    double averageSentimentValue = [
      for (AnalysisModel element
          in ref.watch(AnalysisViewController.analysisModelListProvider))
        element.sentiment!,
    ].average;
    return CustomListTile(
      contentPadding: EdgeInsets.all(gap),
      titleString: 'Average overall sentiment',
      subtitle: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: gap),
            child: SfSlider(
              min: sentimentValues.min,
              max: sentimentValues.max,
              value: averageSentimentValue,
              interval: 1,
              showTicks: true,
              showLabels: true,
              showDividers: true,
              enableTooltip: false,
              minorTicksPerInterval: 0,
              shouldAlwaysShowTooltip: false,
              // labelFormatterCallback: (actualValue, formattedText) {
              //   return sentimentLabels[int.parse(formattedText) + 3];
              // },
              tooltipTextFormatterCallback: (actualValue, formattedText) =>
                  sentimentLabels[averageSentimentValue.toInt() + 3],
              labelPlacement: LabelPlacement.onTicks,
              onChanged: (dynamic value) {
                vibrate(
                  ref.watch(navigationEnableHapticFeedbackProvider),
                  () {},
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: gap),
            child: Text(
              switch (averageSentimentValue) {
                >= 3 => labels[5],
                >= 2 => labels[5],
                >= 1 => labels[4],
                >= 0 => labels[3],
                >= -1 => labels[2],
                >= -2 => labels[1],
                _ => labels[0],
              },
              style: context.theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      leadingIconData: FontAwesomeIcons.circleInfo,
      leadingOnTap: () {
        /// explain to the user what they are seeing
        showHealpenDialog(
          context: context,
          doVibrate: ref.watch(navigationEnableHapticFeedbackProvider),
          customDialog: const CustomDialog(
            titleString: 'What is this?',
            contentString: 'This is the average sentiment value of all '
                'your notes. It is calculated by adding up the '
                'sentiment value of each note and dividing it by the '
                'number of notes you have written.',
          ),
        );
      },
      trailing: Text(
        averageSentimentValue.toStringAsFixed(2),
        style: context.theme.textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
