import 'package:flutter/material.dart' hide AppBar;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../controllers/emotional_echo_controller.dart';
import '../../extensions/int_extensions.dart';
import '../../models/analysis/analysis_model.dart';
import '../../providers/settings_providers.dart';
import '../../utils/constants.dart';
import '../../utils/helper_functions.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/custom_list_tile.dart';
import '../blueprint/blueprint_view.dart';
import '../insights/widgets/insights/emotional_echo/emotional_echo_tile.dart';

class NoteView extends ConsumerWidget {
  const NoteView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final args = ModalRoute.of(context)!.settings.arguments as ({
      AnalysisModel analysisModel
    });
    final AnalysisModel analysisModel = args.analysisModel;
    ref.watch(emotionalEchoControllerProvider).sentimentScore =
        analysisModel.score;
    return BlueprintView(
      appBar: AppBar(
        pathNames: [
          DateFormat('EEE d MMM yyyy').format(
            DateTime.fromMillisecondsSinceEpoch(analysisModel.timestamp),
          ),
        ],
        automaticallyImplyLeading: true,
      ),
      body: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: SingleChildScrollView(
          child: Wrap(
            spacing: gap,
            runSpacing: gap,
            children: [
              CustomListTile(
                responsiveWidth: true,
                useSmallerNavigationSetting:
                    !ref.watch(navigationSmallerNavigationElementsProvider),
                enableExplanationWrapper:
                    !ref.watch(navigationSmallerNavigationElementsProvider),
                titleString: 'Time',
                subtitleString: DateFormat('HH:mm:ss').format(
                  DateTime.fromMillisecondsSinceEpoch(analysisModel.timestamp),
                ),
                subtitlePadding:
                    ref.watch(navigationSmallerNavigationElementsProvider)
                        ? EdgeInsets.zero
                        : EdgeInsets.all(gap),
              ),
              CustomListTile(
                useSmallerNavigationSetting:
                    !ref.watch(navigationSmallerNavigationElementsProvider),
                enableExplanationWrapper:
                    !ref.watch(navigationSmallerNavigationElementsProvider),
                responsiveWidth: true,
                titleString: 'Duration',
                subtitleString: analysisModel.duration.writingDurationFormat(),
                subtitlePadding:
                    ref.watch(navigationSmallerNavigationElementsProvider)
                        ? EdgeInsets.zero
                        : EdgeInsets.all(gap),
              ),
              CustomListTile(
                responsiveWidth: true,
                useSmallerNavigationSetting:
                    !ref.watch(navigationSmallerNavigationElementsProvider),
                enableExplanationWrapper:
                    !ref.watch(navigationSmallerNavigationElementsProvider),
                titleString: 'Word Count',
                subtitleString: '${analysisModel.wordCount}',
                subtitlePadding:
                    ref.watch(navigationSmallerNavigationElementsProvider)
                        ? EdgeInsets.zero
                        : EdgeInsets.all(gap),
              ),
              CustomListTile(
                responsiveWidth: true,
                useSmallerNavigationSetting:
                    !ref.watch(navigationSmallerNavigationElementsProvider),
                enableExplanationWrapper:
                    !ref.watch(navigationSmallerNavigationElementsProvider),
                titleString: 'Content',
                subtitleString: analysisModel.content,
                selectableText: true,
                subtitlePadding:
                    ref.watch(navigationSmallerNavigationElementsProvider)
                        ? EdgeInsets.zero
                        : EdgeInsets.all(gap),
              ),
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
              CustomListTile(
                responsiveWidth: true,
                useSmallerNavigationSetting:
                    !ref.watch(navigationSmallerNavigationElementsProvider),
                enableExplanationWrapper:
                    !ref.watch(navigationSmallerNavigationElementsProvider),
                titleString: 'Icon',
                subtitle: FaIcon(
                  getSentimentIcon(analysisModel.score),
                  color: getShapeColorOnSentiment(
                    context.theme,
                    analysisModel.score,
                  ),
                  size: 10.h,
                ),
                subtitlePadding:
                    ref.watch(navigationSmallerNavigationElementsProvider)
                        ? EdgeInsets.zero
                        : EdgeInsets.all(gap),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
