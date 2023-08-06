import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../controllers/writing_controller.dart';
import '../../../models/snack_bar_options.dart';
import '../../../utils/constants.dart';
import '../../../widgets/custom_list_tile.dart';
import '../../../widgets/custom_snack_bar.dart';

class SaveNoteButton extends ConsumerWidget {
  const SaveNoteButton({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(writingControllerProvider);
    final writingController = ref.watch(writingControllerProvider.notifier);
    return CustomListTile(
      cornerRadius: radius - gap,
      contentPadding: EdgeInsets.symmetric(horizontal: gap),
      onTap: state.content.isNotEmpty
          ? () {
              CustomSnackBar.doActionAndShowSnackBar(
                doAction: writingController.handleSaveNote,
                options: SnackBarOptions(
                  message: 'Saving note...',
                  icon: FontAwesomeIcons.solidFloppyDisk,
                ),
                afterSnackBar: () {
                  CustomSnackBar.showSnackBar(
                    message: 'Note saved!',
                    icon: FontAwesomeIcons.solidCircleCheck,
                  );
                },
              );
            }
          : null,
      backgroundColor:
          state.content.isEmpty ? context.theme.colorScheme.outline : null,
      textColor:
          state.content.isEmpty ? context.theme.colorScheme.background : null,
      responsiveWidth: true,
      titleString: 'Save',
      leadingIconData: FontAwesomeIcons.solidFloppyDisk,
    );
  }
}
