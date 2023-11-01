import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../controllers/healpen/healpen_controller.dart';
import '../../../../controllers/note_analyzer.dart';
import '../../../../providers/settings_providers.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/show_healpen_dialog.dart';
import '../../../../widgets/custom_list_tile.dart';
import 'analyze_notes_dialog.dart';

class AnalyzeNotesTile extends ConsumerWidget {
  const AnalyzeNotesTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomListTile(
      contentPadding: EdgeInsets.all(gap),
      cornerRadius: ref.watch(HealpenController().currentPageIndexProvider) == 0
          ? radius - gap
          : radius,
      enableExplanationWrapper:
          ref.watch(HealpenController().currentPageIndexProvider) == 0
              ? false
              : true,
      titleString: 'Update note analysis',
      explanationString: 'Update the analysis of all your notes.',
      onTap: () async {
        NoteAnalyzer.completed(ref);
        showHealpenDialog(
          context: context,
          doVibrate: ref.watch(navigationEnableHapticFeedbackProvider),
          customDialog: const AnalyzeNotesDialog(),
        );
      },
    );
  }
}
