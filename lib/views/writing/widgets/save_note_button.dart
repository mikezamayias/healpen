import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../controllers/writing_controller.dart';
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
              final snackBarConfig = SnackBarConfig(
                titleString1: 'Save note?',
                leadingIconData1: FontAwesomeIcons.solidFloppyDisk,
                trailingWidgets1: [
                  IconButton.filledTonal(
                    onPressed:
                        scaffoldMessengerKey.currentState!.hideCurrentSnackBar,
                    icon: const FaIcon(
                      FontAwesomeIcons.check,
                    ),
                  ),
                  SizedBox(width: gap),
                  IconButton.filledTonal(
                    onPressed: scaffoldMessengerKey
                        .currentState!.removeCurrentSnackBar,
                    icon: const FaIcon(
                      FontAwesomeIcons.xmark,
                    ),
                  ),
                ],
                actionAfterSnackBar1: writingController.handleSaveNote,
                titleString2: 'Note saved!',
                leadingIconData2: FontAwesomeIcons.solidCircleCheck,
              );
              CustomSnackBar(snackBarConfig).showSnackBar(context);
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
