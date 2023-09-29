import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../controllers/analysis_view_controller.dart';
import '../../../../providers/settings_providers.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/helper_functions.dart';
import '../../../../utils/show_healpen_dialog.dart';
import '../../../../widgets/custom_list_tile.dart';
import 'analyze_notes_dialog.dart';

class AnalyzeNotesTile extends ConsumerWidget {
  const AnalyzeNotesTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomListTile(
      contentPadding: EdgeInsets.all(gap),
      cornerRadius: radius - gap,
      titleString: 'Analyze notes',
      enableExplanationWrapper: false,
      explanationString:
          'Update analysis of existing notes and analyze new ones.',
      onTap: () {
        vibrate(
          ref.watch(navigationReduceHapticFeedbackProvider),
          () async {
            AnalysisViewController.completed(ref);
            showHealpenDialog(
              context: context,
              doVibrate: ref.watch(navigationReduceHapticFeedbackProvider),
              customDialog: const AnalyzeNotesDialog(),
            );
          },
        );
      },
    );
  }
}
