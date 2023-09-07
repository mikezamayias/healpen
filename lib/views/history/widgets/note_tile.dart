import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../controllers/history_view_controller.dart';
import '../../../models/note/note_model.dart';
import '../../../providers/settings_providers.dart';
import '../../../utils/constants.dart';
import '../../../utils/show_healpen_dialog.dart';
import '../../../widgets/custom_dialog.dart';
import '../../../widgets/custom_list_tile.dart';
import '../../../widgets/custom_snack_bar.dart';

class NoteTile extends ConsumerWidget {
  const NoteTile({
    super.key,
    required this.entry,
  });

  final NoteModel entry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: IntrinsicWidth(
        child: Slidable(
          key: ValueKey(entry.timestamp.toString()),
          startActionPane: ActionPane(
            extentRatio: 1,
            motion: const ScrollMotion(),
            dragDismissible: false,
            children: [
              SlidableAction(
                autoClose: false,
                onPressed: (context) {
                  showHealpenDialog(
                    context: context,
                    doVibrate:
                        ref.watch(navigationReduceHapticFeedbackProvider),
                    customDialog: CustomDialog(
                      titleString: entry.isPrivate
                          ? 'Mark note as not private?'
                          : 'Mark note as private?',
                      contentString: entry.content,
                      actions: [
                        CustomListTile(
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: gap * 2),
                          cornerRadius: radius - gap,
                          responsiveWidth: true,
                          titleString: 'Yes',
                          onTap: () {
                            context.navigator.pop(true);
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
                            context.navigator.pop(false);
                          },
                        ),
                      ],
                    ),
                  ).then((exit) {
                    if (exit == null) return;
                    if (exit) {
                      CustomSnackBar(
                        SnackBarConfig(
                          titleString1: entry.isPrivate
                              ? 'Marking note as not private...'
                              : 'Marking note as private...',
                          leadingIconData1: entry.isPrivate
                              ? FontAwesomeIcons.lockOpen
                              : FontAwesomeIcons.lock,
                          actionAfterSnackBar1: () async =>
                              HistoryViewController()
                                  .noteTogglePrivate(noteModel: entry),
                        ),
                      ).showSnackBar(context, ref);
                    }
                  });
                },
                backgroundColor: context.theme.colorScheme.primary,
                foregroundColor: context.theme.colorScheme.onPrimary,
                icon: entry.isPrivate
                    ? FontAwesomeIcons.lockOpen
                    : FontAwesomeIcons.lock,
                borderRadius: BorderRadius.circular(radius),
              ),
              SizedBox(width: gap),
              SlidableAction(
                autoClose: false,
                onPressed: (context) {
                  showHealpenDialog(
                    context: context,
                    doVibrate:
                        ref.watch(navigationReduceHapticFeedbackProvider),
                    customDialog: CustomDialog(
                      titleString: entry.isFavorite
                          ? 'Mark note as not favorite?'
                          : 'Mark note as favorite?',
                      actions: [
                        CustomListTile(
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: gap * 2),
                          cornerRadius: radius - gap,
                          responsiveWidth: true,
                          titleString: 'Yes',
                          onTap: () {
                            context.navigator.pop(true);
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
                            context.navigator.pop(false);
                          },
                        ),
                      ],
                    ),
                  ).then(
                    (exit) {
                      if (exit == null) return;
                      if (exit) {
                        CustomSnackBar(
                          SnackBarConfig(
                            titleString1: entry.isFavorite
                                ? 'Marking note as not favorite...'
                                : 'Marking note as favorite...',
                            leadingIconData1: entry.isFavorite
                                ? FontAwesomeIcons.star
                                : FontAwesomeIcons.solidStar,
                            actionAfterSnackBar1: () async =>
                                HistoryViewController()
                                    .noteToggleFavorite(noteModel: entry),
                          ),
                        ).showSnackBar(context, ref);
                      }
                    },
                  );
                },
                backgroundColor: context.theme.colorScheme.primary,
                foregroundColor: context.theme.colorScheme.onPrimary,
                icon: entry.isFavorite
                    ? FontAwesomeIcons.solidStar
                    : FontAwesomeIcons.star,
                borderRadius: BorderRadius.circular(radius),
              ),
            ],
          ),
          endActionPane: ActionPane(
            motion: const ScrollMotion(),
            dragDismissible: true,
            extentRatio: 1,
            children: [
              SlidableAction(
                autoClose: false,
                onPressed: (context) {
                  showHealpenDialog(
                    context: context,
                    doVibrate:
                        ref.watch(navigationReduceHapticFeedbackProvider),
                    customDialog: CustomDialog(
                      titleString: 'Delete note?',
                      contentString: 'You cannot undo this action.',
                      actions: [
                        CustomListTile(
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: gap * 2),
                          cornerRadius: radius - gap,
                          responsiveWidth: true,
                          titleString: 'Yes',
                          onTap: () {
                            context.navigator.pop(true);
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
                            context.navigator.pop(false);
                          },
                        ),
                      ],
                    ),
                  ).then(
                    (exit) {
                      if (exit == null) return;
                      if (exit) {
                        CustomSnackBar(
                          SnackBarConfig(
                            titleString1: 'Deleting note...',
                            leadingIconData1: FontAwesomeIcons.trashCan,
                            actionAfterSnackBar1: () async =>
                                HistoryViewController()
                                    .deleteNote(noteModel: entry),
                            trailingWidgets1: [
                              CustomListTile(
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: gap,
                                ),
                                cornerRadius: radius - gap,
                                responsiveWidth: true,
                                backgroundColor:
                                    context.theme.colorScheme.primaryContainer,
                                textColor: context
                                    .theme.colorScheme.onPrimaryContainer,
                                onTap: scaffoldMessengerKey
                                    .currentState!.removeCurrentSnackBar,
                                titleString: 'Cancel',
                                leadingIconData: FontAwesomeIcons.xmark,
                              ),
                            ],
                          ),
                        ).showSnackBar(context, ref);
                      }
                    },
                  );
                },
                backgroundColor: context.theme.colorScheme.tertiary,
                foregroundColor: context.theme.colorScheme.onTertiary,
                icon: FontAwesomeIcons.trashCan,
                borderRadius: BorderRadius.circular(radius),
                padding: EdgeInsets.zero,
              ),
            ],
          ),
          child: CustomListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: gap * 2),
            title: Text(
              entry.content,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.theme.textTheme.titleMedium!
                  .copyWith(color: context.theme.colorScheme.onPrimary),
            ),
            onTap: () => context.navigator.pushNamed(
              '/note',
              arguments: entry,
            ),
          ),
        ),
      ),
    );
  }
}
