import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../controllers/emotional_echo_controller.dart';
import '../../../models/analysis/analysis_model.dart';
import '../../../providers/settings_providers.dart';
import '../../../utils/constants.dart';
import '../../../widgets/custom_list_tile.dart';
import '../../insights/widgets/insights/emotional_echo/emotional_echo_tile.dart';

class AnalysisPage extends ConsumerWidget {
  final AnalysisModel analysisModel;

  const AnalysisPage({
    super.key,
    required this.analysisModel,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(emotionalEchoControllerProvider).sentimentScore =
        analysisModel.score;
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
            titleString: 'Sentiment',
            subtitle: SizedBox(
              height: 39.h,
              child: const EmotionalEchoTile(),
            ),
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
