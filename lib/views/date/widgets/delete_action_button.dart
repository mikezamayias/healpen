import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../controllers/date_view_controller.dart';
import '../../../extensions/context_extensions.dart';
import '../../../extensions/widget_extensions.dart';
import '../../../models/note_tile_model.dart';
import '../../../utils/constants.dart';
import '../../../utils/logger.dart';
import '../../../utils/show_healpen_dialog.dart';
import '../../../widgets/custom_dialog.dart';
import '../../../widgets/custom_list_tile.dart';
import 'date_view_action_button.dart';

class DeleteActionButton extends ConsumerWidget {
  const DeleteActionButton({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DateViewActionButton(
      foregroundColor: context.theme.colorScheme.onError,
      backgroundColor: context.theme.colorScheme.error,
      titleString: 'Delete',
      onTap: DateViewController.someNotesSelected(ref)
          ? () {
              showHealpenDialog<bool>(
                context: context,
                customDialog: CustomDialog(
                  titleString: 'Are you sure',
                  enableContentContainer: false,
                  contentWidget: Padding(
                    padding: EdgeInsets.all(gap),
                    child: dialogContents(ref),
                  ),
                  textColor: context.theme.colorScheme.error,
                  actions: <CustomListTile>[
                    CustomListTile(
                      cornerRadius: radius - gap,
                      responsiveWidth: true,
                      contentPadding: EdgeInsets.all(gap),
                      titleString: 'Cancel',
                      onTap: () => context.navigator.pop(false),
                    ),
                    CustomListTile(
                      cornerRadius: radius - gap,
                      responsiveWidth: true,
                      contentPadding: EdgeInsets.all(gap),
                      titleString: 'Delete',
                      onTap: () => context.navigator.pop(true),
                      backgroundColor: context.theme.colorScheme.error,
                      textColor: context.theme.colorScheme.onError,
                    ),
                  ],
                ),
              ).then((bool? value) {
                if (value != null && value) {
                  context.showSuccessSnackBar(
                    message: 'Notes deleted',
                  );
                  DateViewController.deleteSelectedNotes(ref);
                } else {
                  logger.i('Delete cancelled');
                }
              });
            }
          : null,
    );
  }

  Widget dialogContents(WidgetRef ref) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        CustomListTile(
          cornerRadius: radius - gap,
          explanationPadding: EdgeInsets.all(gap),
          contentPadding: EdgeInsets.zero,
          explanationString: 'This action cannot be undone.'
              ' Are you sure you want to delete the selected'
              ' notes?',
        ),
        Flexible(
          child: SizedBox(
            width: 72.w,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: ref
                    .read(DateViewController.selectedNoteModelsProvider)
                    .map(
                      (NoteTileModel noteTileModel) => CustomListTile(
                        cornerRadius: radius - gap,
                        contentPadding: EdgeInsets.zero,
                        explanationPadding: EdgeInsets.all(gap),
                        explanationString: noteTileModel
                                    .analysisModel.content.length >=
                                30
                            ? '${noteTileModel.analysisModel.content.substring(0, 30)}...'
                            : noteTileModel.analysisModel.content,
                      ),
                    )
                    .toList()
                    .addSpacer(
                      SizedBox(height: gap),
                      spacerAtEnd: false,
                      spacerAtStart: false,
                    ),
              ),
            ),
          ),
        ),
      ].addSpacer(
        SizedBox(height: gap),
        spacerAtEnd: false,
        spacerAtStart: false,
      ),
    );
  }
}
