import 'package:flutter/material.dart' hide AppBar;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../extensions/int_extensions.dart';
import '../../models/analysis/analysis_model.dart';
import '../../models/sentence/sentence_model.dart';
import '../../providers/settings_providers.dart';
import '../../utils/constants.dart';
import '../../utils/helper_functions.dart';
import '../../utils/logger.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/custom_list_tile.dart';
import '../blueprint/blueprint_view.dart';
import '../insights/widgets/insights/emotional_echo/emotional_echo_tile.dart';
import '../simple/simple_blueprint_view.dart';
import '../simple/widgets/simple_app_bar.dart';

class NoteView extends ConsumerStatefulWidget {
  const NoteView({super.key});

  @override
  ConsumerState<NoteView> createState() => _NoteViewState();
}

class _NoteViewState extends ConsumerState<NoteView> {
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
      borderRadius: BorderRadius.circular(gap),
      child: SingleChildScrollView(
        child: Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            buildCustomListTile(
              'Time',
              DateFormat('HH:mm:ss').format(
                DateTime.fromMillisecondsSinceEpoch(analysisModel.timestamp),
              ),
            ),
            buildCustomListTile(
              'Duration',
              analysisModel.duration.writingDurationFormat(),
            ),
            CustomListTile(
              responsiveWidth: false,
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
              titleString: 'Emotional Echo',
              subtitle: SizedBox(
                height: 39.h,
                child: const EmotionalEchoTile(),
              ),
            ),
            buildCustomListTile(
              'Sentence Count',
              '${analysisModel.sentences.length}',
            ),
            buildCustomListTile(
              'Word Count',
              '${analysisModel.wordCount}',
            ),
          ],
        ),
      ),
    );
    final titleString = DateFormat('EEE d MMM yyyy').format(
      DateTime.fromMillisecondsSinceEpoch(analysisModel.timestamp),
    );
    return ref.watch(navigationSimpleUIProvider)
        ? SimpleBlueprintView(
            simpleUiAppBar: SimpleAppBar(
              appBarTitleString: titleString,
              appBarTrailing: FaIcon(
                getSentimentIcon(analysisModel.score),
                color: getShapeColorOnSentiment(
                  context.theme,
                  analysisModel.score,
                ),
                size: context.theme.textTheme.displaySmall!.fontSize,
              ),
            ),
            body: body,
          )
        : BlueprintView(
            appBar: AppBar(
              pathNames: [titleString],
              automaticallyImplyLeading: true,
            ),
            body: body,
          );
  }

  Widget buildCustomListTile(String fieldName, dynamic fieldValue) {
    assert(fieldValue is String || fieldValue is Widget);
    return CustomListTile(
      useSmallerNavigationSetting:
          !ref.watch(navigationSmallerNavigationElementsProvider),
      enableExplanationWrapper:
          !ref.watch(navigationSmallerNavigationElementsProvider),
      titleString: fieldName,
      trailing: fieldValue is Widget
          ? fieldValue
          : Text(
              fieldValue,
              style: context.theme.textTheme.titleLarge,
            ),
      subtitlePadding: ref.watch(navigationSmallerNavigationElementsProvider)
          ? EdgeInsets.zero
          : EdgeInsets.all(gap),
    );
  }
}
