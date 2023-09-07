import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../controllers/writing_controller.dart';
import '../../../providers/settings_providers.dart';
import '../../../utils/constants.dart';
import '../../../utils/show_healpen_dialog.dart';
import '../../../widgets/custom_dialog.dart';
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
              showHealpenDialog(
                context: context,
                doVibrate: ref.watch(navigationReduceHapticFeedbackProvider),
                customDialog: CustomDialog(
                  titleString: 'Save note?',
                  actions: [
                    CustomListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: gap * 2),
                      cornerRadius: radius - gap,
                      responsiveWidth: true,
                      titleString: 'Yes',
                      onTap: () {
                        context.navigator.pop(true);
                      },
                    ),
                    SizedBox(width: gap),
                    CustomListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: gap * 2),
                      cornerRadius: radius - gap,
                      responsiveWidth: true,
                      titleString: 'No',
                      onTap: () {
                        context.navigator.pop();
                      },
                    ),
                  ],
                ),
              ).then((exit) {
                if (exit == null) return;
                if (exit) {
                  CustomSnackBar(
                    SnackBarConfig(
                      titleString1: 'Saving note...',
                      leadingIconData1: FontAwesomeIcons.solidFloppyDisk,
                      trailingWidgets1: [
                        CustomListTile(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: gap,
                          ),
                          cornerRadius: radius - gap,
                          responsiveWidth: true,
                          backgroundColor:
                              context.theme.colorScheme.primaryContainer,
                          textColor:
                              context.theme.colorScheme.onPrimaryContainer,
                          onTap: scaffoldMessengerKey
                              .currentState!.removeCurrentSnackBar,
                          titleString: 'Cancel',
                          leadingIconData: FontAwesomeIcons.xmark,
                        ),
                      ],
                      actionAfterSnackBar1: writingController.handleSaveNote,
                    ),
                  ).showSnackBar(context, ref);
                }
              });
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
