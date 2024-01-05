import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../controllers/writing_controller.dart';
import '../../../extensions/context_extensions.dart';
import '../../../utils/logger.dart';
import 'writing_action_button.dart';

class SaveNoteButton extends ConsumerWidget {
  const SaveNoteButton({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(writingControllerProvider);
    final writingController = ref.watch(writingControllerProvider.notifier);
    return WritingActionButton.withIcon(
      titleString: 'Save note',
      iconData: FontAwesomeIcons.solidFloppyDisk,
      condition: state.content.isNotEmpty,
      backgroundColor: context.theme.colorScheme.primary,
      foregroundColor: context.theme.colorScheme.onPrimary,
      onTap: () {
        writingController.handleSaveNote().then(
          (_) {
            context.showSuccessSnackBar(
              message: 'Note saved',
            );
          },
        ).catchError(
          (error) {
            logger.e(error);
            context.showErrorSnackBar(
              message: 'Error while saving note',
              explanation: error.toString(),
            );
          },
        );
      },
    );
  }
}
