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

class AnalysisPage extends ConsumerWidget {
  final AnalysisModel analysisModel;

  const AnalysisPage({
    super.key,
    required this.analysisModel,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var minValue = sentimentValues.min();
    var maxValue = sentimentValues.max();
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: gap),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          CustomListTile(
            useSmallerNavigationSetting:
                !ref.watch(navigationSmallerNavigationElementsProvider),
            enableExplanationWrapper:
                !ref.watch(navigationSmallerNavigationElementsProvider),
            title: Text(
              getSentimentLabel(analysisModel.score),
              style: context.theme.textTheme.titleLarge!.copyWith(
                color: getShapeColorOnSentiment(
                    context.theme, analysisModel.score),
                fontWeight: FontWeight.bold,
              ),
            ),
            leading: FaIcon(
              getSentimentIcon(analysisModel.score),
              size: radius * 2,
              color:
                  getShapeColorOnSentiment(context.theme, analysisModel.score),
            ),
            trailing: Text(
              analysisModel.score.toStringAsFixed(2),
              style: context.theme.textTheme.titleLarge!.copyWith(
                color: getShapeColorOnSentiment(
                    context.theme, analysisModel.score),
                fontWeight: FontWeight.bold,
              ),
            ),
            explanationString: 'The sentiment score is a metric that indicates '
                'the overall emotional tone of the text. It ranges from '
                '$minValue to $maxValue, where $minValue is the most negative '
                'and $maxValue is the most positive.',
          ),
          Gap(gap),
          CustomListTile(
            useSmallerNavigationSetting:
                !ref.watch(navigationSmallerNavigationElementsProvider),
            enableExplanationWrapper:
                !ref.watch(navigationSmallerNavigationElementsProvider),
            titleString: 'Word Count',
            trailing: Text(
              '${analysisModel.wordCount}',
              style: context.theme.textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            explanationString: 'The number of sentences in your note.',
          ),
        ],
      ),
    );
  }
}
