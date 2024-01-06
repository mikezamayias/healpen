import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';

import '../../../controllers/emotional_echo_controller.dart';
import '../../../extensions/int_extensions.dart';
import '../../../models/analysis/analysis_model.dart';
import '../../../providers/settings_providers.dart';
import '../../../route_controller.dart';
import '../../../utils/constants.dart';
import '../../../utils/helper_functions.dart';
import '../../../widgets/custom_list_tile.dart';

class NoteTile extends ConsumerWidget {
  const NoteTile({
    super.key,
    required this.analysisModel,
  });

  final AnalysisModel analysisModel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Color shapeColor =
        getShapeColorOnSentiment(context.theme, analysisModel.score);
    Color textColor =
        getTextColorOnSentiment(context.theme, analysisModel.score);
    return ClipRRect(
      borderRadius: BorderRadius.circular(gap),
      child: CustomListTile(
        useSmallerNavigationSetting: false,
        textColor: textColor,
        backgroundColor: shapeColor,
        cornerRadius: radius - gap,
        padExplanation:
            true == ref.watch(navigationSmallerNavigationElementsProvider),
        explanationString: analysisModel.timestamp.timestampToHHMM(),
        title: Text(
          analysisModel.content,
          style: context.theme.textTheme.bodyLarge!.copyWith(
            overflow: TextOverflow.ellipsis,
            color: textColor,
          ),
          maxLines: 3,
        ),
        onTap: () {
          pushNamedWithAnimation(
            context: context,
            routeName: RouterController.noteViewRoute.route,
            arguments: (analysisModel: analysisModel),
            dataCallback: () {
              ref.read(EmotionalEchoController.scoreProvider.notifier).state =
                  analysisModel.score;
            },
          );
        },
      ),
    );
  }
}
