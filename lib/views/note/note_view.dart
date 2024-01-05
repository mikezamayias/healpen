import 'package:flutter/material.dart' hide AppBar;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../extensions/int_extensions.dart';
import '../../extensions/widget_extensions.dart';
import '../../models/analysis/analysis_model.dart';
import '../../models/sentence/sentence_model.dart';
import '../../providers/settings_providers.dart';
import '../../utils/constants.dart';
import '../../utils/logger.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/custom_list_tile.dart';
import '../blueprint/blueprint_view.dart';
import '../insights/widgets/insights/emotional_echo/emotional_echo_tile.dart';
import 'widgets/sentiment_trailing.dart';

final showEmojiInTrailingProvider = StateProvider<bool>((ref) => true);

class NoteView extends ConsumerStatefulWidget {
  const NoteView({super.key});

  @override
  ConsumerState<NoteView> createState() => _NoteViewState();
}

class _NoteViewState extends ConsumerState<NoteView> {
  bool get useSmallerNavigationElements =>
      ref.watch(navigationSmallerNavigationElementsProvider);

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ({
      AnalysisModel analysisModel
    });
    final AnalysisModel analysisModel = args.analysisModel;
    logger.i(
      analysisModel.sentences.toString(),
    );
    for (SentenceModel sentence in analysisModel.sentences) {
      logger.i(
        sentence.toString(),
      );
    }
    Widget body = ClipRRect(
      borderRadius: BorderRadius.circular(
        useSmallerNavigationElements ? radius : gap,
      ),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: buildCustomListTile(
                    'Time',
                    analysisModel.timestamp.timestampToHHMM(),
                  ),
                ),
                Expanded(
                  child: buildCustomListTile(
                    'Duration',
                    analysisModel.duration.writingDurationFormat(),
                  ),
                ),
              ].addSpacer(
                SizedBox(width: gap),
                spacerAtEnd: false,
                spacerAtStart: false,
              ),
            ),
            CustomListTile(
              responsiveWidth: false,
              selectableText: true,
              titleString: 'Content',
              enableExplanationWrapper: true,
              explanationString: analysisModel.content,
            ),
            CustomListTile(
              titleString: 'Emotional Echo',
              subtitle: SizedBox(
                height: 39.h,
                child: const EmotionalEchoTile(),
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: buildCustomListTile(
                    'Sentence Count',
                    '${analysisModel.sentences.length}',
                  ),
                ),
                buildCustomListTile(
                  'Word Count',
                  '${analysisModel.wordCount}',
                ),
              ].addSpacer(
                SizedBox(width: gap),
                spacerAtEnd: false,
                spacerAtStart: false,
              ),
            ),
          ].addSpacer(
            SizedBox(height: gap),
            spacerAtEnd: false,
            spacerAtStart: false,
          ),
        ),
      ),
    );
    final titleString = analysisModel.timestamp.timestampToEEEEMMMd();
    return BlueprintView(
      appBar: AppBar(
        pathNames: [titleString],
        automaticallyImplyLeading: true,
        trailingWidget: SentimentTrailing(
          score: analysisModel.score,
        ),
      ),
      body: body,
    );
  }

  Widget buildCustomListTile(String fieldName, String fieldValue) {
    return CustomListTile(
      responsiveWidth: true,
      useSmallerNavigationSetting:
          !ref.watch(navigationSmallerNavigationElementsProvider),
      title: Text(
        fieldName,
        style: context.theme.textTheme.titleLarge!.copyWith(
          fontWeight: FontWeight.w700,
        ),
      ),
      subtitle: Padding(
        padding: EdgeInsets.all(gap),
        child: Text(
          fieldValue,
          style: context.theme.textTheme.titleLarge,
        ),
      ),
    );
  }
}
