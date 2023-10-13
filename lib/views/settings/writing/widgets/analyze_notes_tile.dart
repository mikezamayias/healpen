import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../controllers/note_analyzer.dart';
import '../../../../controllers/settings/preferences_controller.dart';
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
      cornerRadius: radius,
      enableExplanationWrapper: true,
      titleString: 'Update note analysis',
      explanationString: 'Update the analysis of all your notes.',
      onTap: () {
        vibrate(
          PreferencesController.navigationEnableHapticFeedback.value,
          () async {
            NoteAnalyzer.completed(ref);
            showHealpenDialog(
              context: context,
              doVibrate:
                  PreferencesController.navigationEnableHapticFeedback.value,
              customDialog: const AnalyzeNotesDialog(),
            );
          },
        );
      },
    );
  }
}
