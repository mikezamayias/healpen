import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../controllers/writing_controller.dart';
import '../../../utils/constants.dart';
import '../../../widgets/custom_list_tile.dart';

class SaveNoteButton extends ConsumerWidget {
  const SaveNoteButton({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(writingControllerProvider);
    final writingController = ref.watch(writingControllerProvider.notifier);
    final writingTextController =
        ref.watch(writingControllerProvider.notifier).textController;
    return CustomListTile(
      cornerRadius: radius - gap,
      contentPadding: EdgeInsets.symmetric(horizontal: gap),
      onTap: () {
        if (state.content.isNotEmpty) {
          writingController.handleSaveNote(); // Saves entry
          writingTextController.clear(); // Clears the TextFormField
          writingController.resetText(); // Resets the text in the state
        }
      },
      backgroundColor:
          state.content.isEmpty || writingTextController.text.isEmpty
              ? context.theme.colorScheme.outline
              : null,
      textColor: state.content.isEmpty || writingTextController.text.isEmpty
          ? context.theme.colorScheme.background
          : null,
      responsiveWidth: true,
      titleString: 'Save',
      leadingIconData: FontAwesomeIcons.solidFloppyDisk,
    );
  }
}
