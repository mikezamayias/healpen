import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../controllers/writing_controller.dart';
import '../../../utils/constants.dart';
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
              final snackBarConfig = SnackBarConfig(
                titleString1: 'Note saved!',
                leadingIconData1: FontAwesomeIcons.solidCircleCheck,
              );
              showDialog(
                context: context,
                barrierDismissible: false,
                barrierColor:
                    context.theme.colorScheme.background.withOpacity(0.8),
                builder: (BuildContext context) {
                  return CustomDialog(
                    titleString: 'Save note?',
                    actions: [
                      CustomListTile(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: gap * 2),
                        cornerRadius: radius - gap,
                        responsiveWidth: true,
                        titleString: 'Yes',
                        onTap: () {
                          writingController.handleSaveNote().then((_) {
                            CustomSnackBar(snackBarConfig)
                                .showSnackBar(context, ref);
                          });
                          context.navigator.pop();
                        },
                      ),
                      SizedBox(width: gap),
                      CustomListTile(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: gap * 2),
                        cornerRadius: radius - gap,
                        responsiveWidth: true,
                        titleString: 'No',
                        onTap: () {
                          context.navigator.pop();
                        },
                      ),
                    ],
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
