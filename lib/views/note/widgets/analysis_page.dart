import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../extensions/number_extensions.dart';
import '../../../models/analysis/analysis_model.dart';
import '../../../providers/settings_providers.dart';
import '../../../utils/constants.dart';
import '../../../utils/helper_functions.dart';
import '../../../widgets/custom_list_tile.dart';
import '../../../widgets/text_divider.dart';

class AnalysisPage extends ConsumerWidget {
  final AnalysisModel analysisModel;

  const AnalysisPage({
    super.key,
    required this.analysisModel,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    log('$analysisModel');
    var minValue = sentimentValues.min();
    var maxValue = sentimentValues.max();
    double sentimentRatio =
        (analysisModel.sentiment! + 3) / (sentimentLabels.length - 1);
    Color sentimentColor = Color.lerp(
      ref.watch(themeProvider).colorScheme.error,
      ref.watch(themeProvider).colorScheme.primary,
      sentimentRatio,
    )!;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: gap),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const TextDivider('Analysis'),
          Gap(gap),
          CustomListTile(
            contentPadding: EdgeInsets.all(gap),
            title: Text(
              getSentimentLabel(analysisModel.sentiment!),
              style: context.theme.textTheme.titleLarge!.copyWith(
                color: sentimentColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            leading: FaIcon(
              getSentimentIcon(analysisModel.sentiment!),
              size: radius * 2,
              color: sentimentColor,
            ),
            trailing: Text(
              analysisModel.sentiment!.toStringAsFixed(2),
              style: context.theme.textTheme.titleLarge!.copyWith(
                color: sentimentColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            enableExplanationWrapper: true,
            explanationString: 'Sentiment is a metric that indicates the '
                'overall emotional tone of the text. It ranges from $minValue '
                'to $maxValue, where $minValue is the most negative and '
                '$maxValue is the most positive.',
          ),
          Gap(gap),
          CustomListTile(
            titleString: 'Sentence Count',
            trailing: Text(
              '${analysisModel.wordCount}',
              style: context.theme.textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            enableExplanationWrapper: true,
            explanationString: 'The number of sentences in your note.',
          ),
        ],
      ),
    );
  }
}
