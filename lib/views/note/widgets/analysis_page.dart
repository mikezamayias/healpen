import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../extensions/number_extensions.dart';
import '../../../models/analysis/analysis_model.dart';
import '../../../utils/constants.dart';
import '../../../utils/helper_functions.dart';
import '../../../widgets/custom_list_tile.dart';
import '../../../widgets/text_divider.dart';

class AnalysisPage extends StatelessWidget {
  final AnalysisModel analysisModel;

  const AnalysisPage({
    super.key,
    required this.analysisModel,
  });

  @override
  Widget build(BuildContext context) {
    log('$analysisModel');
    var minValue = sentimentValues.min();
    var maxValue = sentimentValues.max();
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: gap),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const TextDivider('Analysis'),
          Gap(gap),
          CustomListTile(
            titleString: 'Sentiment',
            contentPadding: EdgeInsets.all(gap),
            subtitleString: getSentimentLabel(analysisModel.sentiment!),
            leading: FaIcon(
              getSentimentIcon(analysisModel.sentiment!),
              color: context.theme.colorScheme.secondary,
              size: radius * 2,
            ),
            trailing: Text(
              analysisModel.sentiment!.toStringAsFixed(2),
              style: context.theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            explanationString: 'Sentiment is a metric that indicates the '
                'overall emotional tone of the text. It ranges from $minValue '
                'to $maxValue, where $minValue is the most negative and '
                '$maxValue is the most positive.',
          ),
          Gap(gap),
          CustomListTile(
            titleString: 'Sentence Count',
            subtitleString: '${analysisModel.wordCount}',
            explanationString: 'The number of sentences in your note.',
          ),
        ],
      ),
    );
  }
}
