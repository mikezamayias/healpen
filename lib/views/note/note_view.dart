import 'package:flutter/material.dart' hide AppBar;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../controllers/emotional_echo_controller.dart';
import '../../extensions/int_extensions.dart';
import '../../models/analysis/analysis_model.dart';
import '../../models/note/note_model.dart';
import '../../providers/settings_providers.dart';
import '../../utils/constants.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/custom_list_tile.dart';
import '../blueprint/blueprint_view.dart';
import '../insights/widgets/insights/emotional_echo/emotional_echo_tile.dart';

class NoteView extends ConsumerWidget {
  const NoteView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final args = ModalRoute.of(context)!.settings.arguments as ({
      NoteModel noteModel,
      AnalysisModel? analysisModel
    });
    final NoteModel noteModel = args.noteModel;
    final AnalysisModel? analysisModel = args.analysisModel;
    final showAnalysis = !noteModel.isPrivate && analysisModel != null;
    if (showAnalysis) {
      ref.watch(emotionalEchoControllerProvider).sentimentScore =
          analysisModel.score;
    }
    return BlueprintView(
      appBar: AppBar(
        pathNames: [
          DateFormat('EEE d MMM yyyy').format(
            DateTime.fromMillisecondsSinceEpoch(noteModel.timestamp),
          ),
          DateFormat('HH:mm:ss').format(
            DateTime.fromMillisecondsSinceEpoch(noteModel.timestamp),
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
                useSmallerNavigationSetting:
                    !ref.watch(navigationSmallerNavigationElementsProvider),
                enableExplanationWrapper:
                    !ref.watch(navigationSmallerNavigationElementsProvider),
                titleString: 'Content',
                subtitleString: noteModel.content,
                selectableText: true,
                subtitlePadding:
                    ref.watch(navigationSmallerNavigationElementsProvider)
                        ? EdgeInsets.zero
                        : EdgeInsets.all(gap),
              ),
              if (showAnalysis)
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
                useSmallerNavigationSetting:
                    !ref.watch(navigationSmallerNavigationElementsProvider),
                enableExplanationWrapper:
                    !ref.watch(navigationSmallerNavigationElementsProvider),
                responsiveWidth: true,
                titleString: 'Duration',
                subtitleString: noteModel.duration.writingDurationFormat(),
                subtitlePadding:
                    ref.watch(navigationSmallerNavigationElementsProvider)
                        ? EdgeInsets.zero
                        : EdgeInsets.all(gap),
              ),
              if (showAnalysis)
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
            ],
          ),
        ),
      ),
    );
  }
}
