import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';

import '../../../../controllers/note_analyzer.dart';
import '../../../../utils/constants.dart';
import '../../../../widgets/custom_dialog.dart';
import '../../../../widgets/custom_list_tile.dart';

class AnalyzeNotesDialog extends ConsumerWidget {
  const AnalyzeNotesDialog({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double progressValue = 0;
    if (ref.watch(NoteAnalyzer.listToAnalyzeLengthProvider) != 0) {
      progressValue = ref.watch(NoteAnalyzer.progressProvider) /
          ref.watch(NoteAnalyzer.listToAnalyzeLengthProvider);
    }
    return CustomDialog(
      titleString: 'Updating note analysis',
      enableContentContainer: false,
      contentWidget: Padding(
        padding: EdgeInsets.all(gap),
        child: CustomListTile(
          // backgroundColor: context.theme.colorScheme.surface,
          // textColor: context.theme.colorScheme.onSurface,
          cornerRadius: radius - gap,

          titleString: switch (
              ref.watch(NoteAnalyzer.analysisProgressProvider)) {
            AnalysisProgress.removingPreviousAnalysis =>
              'Removing previous analysis',
            AnalysisProgress.analyzingNotes => 'Analyzing notes',
            AnalysisProgress.completed => 'Completed',
          },
          enableSubtitleWrapper: false,
          subtitle: switch (ref.watch(NoteAnalyzer.analysisProgressProvider)) {
            AnalysisProgress.completed => null,
            _ => ClipRRect(
                borderRadius: BorderRadius.circular(radius),
                child: LinearProgressIndicator(
                  color: context.theme.colorScheme.primary,
                  backgroundColor: context.theme.colorScheme.surfaceVariant,
                  value: progressValue,
                ),
              ),
          },
          enableExplanationWrapper: false,
          explanationString: switch (
              ref.watch(NoteAnalyzer.analysisProgressProvider)) {
            AnalysisProgress.completed => 'You can now close this dialog.',
            _ =>
              '${ref.watch(NoteAnalyzer.progressProvider)} / ${ref.watch(NoteAnalyzer.listToAnalyzeLengthProvider)}\nPlease don\'t exit the app.',
          },
        ),
      ),
      actions: [
        CustomListTile(
          cornerRadius: radius - gap,
          responsiveWidth: true,
          titleString: 'Close',
          onTap: switch (ref.watch(NoteAnalyzer.analysisProgressProvider)) {
            AnalysisProgress.completed => () {
                context.navigator.pop();
              },
            _ => null
          },
        ),
      ],
    );
  }
}
