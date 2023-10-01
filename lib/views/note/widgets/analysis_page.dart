import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../models/analysis/analysis_model.dart';
import '../../../utils/constants.dart';
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
    final labels = [
      'Very Unpleasant',
      'Unpleasant',
      'Slightly Unpleasant',
      'Neutral',
      'Slightly Pleasant',
      'Pleasant',
      'Very Pleasant'
    ];
    final sentimentIcons = [
      FontAwesomeIcons.faceSadTear,
      FontAwesomeIcons.faceFrown,
      FontAwesomeIcons.faceFrownOpen,
      FontAwesomeIcons.faceMeh,
      FontAwesomeIcons.faceSmile,
      FontAwesomeIcons.faceLaugh,
      FontAwesomeIcons.faceLaughBeam,
    ];
    log('$analysisModel');
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: gap),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: gap),
            child: const TextDivider('Analysis'),
          ),
          CustomListTile(
            titleString: 'Sentiment',
            contentPadding: EdgeInsets.all(gap),
            subtitleString: switch (analysisModel.sentiment!) {
              >= 3 => labels[5],
              >= 2 => labels[5],
              >= 1 => labels[4],
              >= 0 => labels[3],
              >= -1 => labels[2],
              >= -2 => labels[1],
              _ => labels[0],
            },
            leading: FaIcon(
              switch (analysisModel.sentiment!) {
                >= 3 => sentimentIcons[5],
                >= 2 => sentimentIcons[5],
                >= 1 => sentimentIcons[4],
                >= 0 => sentimentIcons[3],
                >= -1 => sentimentIcons[2],
                >= -2 => sentimentIcons[1],
                _ => sentimentIcons[0],
              },
              color: context.theme.colorScheme.secondary,
              size: radius * 2,
            ),
            trailing: Text(
              analysisModel.sentiment!.toStringAsFixed(2),
              style: context.theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            explanationString: '''
Sentiment is a metric that indicates the overall emotional tone of the text. It ranges from -3 to 3, where -3 is the most negative and 3 is the most positive.''',
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
