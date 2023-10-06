import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';

import '../../../../controllers/analysis_view_controller.dart';
import '../../../../providers/settings_providers.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/helper_functions.dart';
import '../../../../widgets/custom_dialog.dart';
import '../../../../widgets/custom_list_tile.dart';

class AnalyzeNotesDialog extends ConsumerWidget {
  const AnalyzeNotesDialog({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double progressValue = 0;
    if (ref.watch(AnalysisViewController.listToAnalyzeLengthProvider) != 0) {
      progressValue = ref.watch(AnalysisViewController.progressProvider) /
          ref.watch(AnalysisViewController.listToAnalyzeLengthProvider);
    }
    return CustomDialog(
      titleString: 'Updating note analysis',
      enableContentContainer: false,
      contentWidget: Padding(
        padding: EdgeInsets.all(gap),
        child: CustomListTile(
          backgroundColor: context.theme.colorScheme.surface,
          textColor: context.theme.colorScheme.onSurface,
          cornerRadius: radius - gap,
          contentPadding: EdgeInsets.all(gap),
          titleString: switch (
              ref.watch(AnalysisViewController.analysisProgressProvider)) {
            AnalysisProgress.removingPreviousAnalysis =>
              'Removing previous analysis',
            AnalysisProgress.analyzingNotes => 'Analyzing notes',
            AnalysisProgress.completed => 'Completed',
          },
          enableSubtitleWrapper: false,
          subtitle: switch (
              ref.watch(AnalysisViewController.analysisProgressProvider)) {
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
              ref.watch(AnalysisViewController.analysisProgressProvider)) {
            AnalysisProgress.completed => 'You can now close this dialog.',
            _ =>
              '${ref.watch(AnalysisViewController.progressProvider)} / ${ref.watch(AnalysisViewController.listToAnalyzeLengthProvider)}\nPlease don\'t exit the app.',
          },
        ),
      ),
      actions: [
        CustomListTile(
          cornerRadius: radius - gap,
          responsiveWidth: true,
          titleString: 'Close',
          onTap: switch (
              ref.watch(AnalysisViewController.analysisProgressProvider)) {
            AnalysisProgress.completed => () {
                vibrate(
                  ref.watch(navigationEnableHapticFeedbackProvider),
                  () {
                    context.navigator.pop();
                  },
                );
              },
            _ => null
          },
        ),
      ],
    );
  }
}
