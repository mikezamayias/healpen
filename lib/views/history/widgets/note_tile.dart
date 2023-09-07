import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../controllers/history_view_controller.dart';
import '../../../models/note/note_model.dart';
import '../../../utils/constants.dart';
import '../../../utils/showHealpenDialog.dart';
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
                onPressed: (context) {
                  showHealpenDialog(
                    context: context,
                    customDialog: CustomDialog(
                      titleString: entry.isPrivate
                          ? 'Mark note as not private?'
                          : 'Mark note as private?',
                      actions: [
                        CustomListTile(
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: gap * 2),
                          cornerRadius: radius - gap,
                          responsiveWidth: true,
                          titleString: 'Yes',
                          onTap: () {
                            HistoryViewController()
                                .noteTogglePrivate(noteModel: entry)
                                .then((_) {
                              CustomSnackBar(
                                SnackBarConfig(
                                  titleString1: entry.isPrivate
                                      ? 'Note marked as not private!'
                                      : 'Note marked as private!',
                                  leadingIconData1:
                                      FontAwesomeIcons.solidCircleCheck,
                                ),
                              ).showSnackBar(context, ref);
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
                          onTap: context.navigator.pop,
                        ),
                      ],
                    ),
                  );
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
                onPressed: (context) {
                  showHealpenDialog(
                    context: context,
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
                            HistoryViewController()
                                .noteToggleFavorite(noteModel: entry)
                                .then((_) {
                              CustomSnackBar(
                                SnackBarConfig(
                                  titleString1: entry.isFavorite
                                      ? 'Note unmarked as favorite!'
                                      : 'Note marked as favorite!',
                                  leadingIconData1:
                                      FontAwesomeIcons.solidCircleCheck,
                                ),
                              ).showSnackBar(context, ref);
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
                    ),
                  );
                },
                backgroundColor: context.theme.colorScheme.primary,
                foregroundColor: context.theme.colorScheme.onPrimary,
                icon: entry.isFavorite
                    ? FontAwesomeIcons.star
                    : FontAwesomeIcons.solidStar,
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
                onPressed: (context) {
                  showHealpenDialog(
                    context: context,
                    customDialog: CustomDialog(
                      titleString: 'Delete note?',
                      actions: [
                        CustomListTile(
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: gap * 2),
                          cornerRadius: radius - gap,
                          responsiveWidth: true,
                          titleString: 'Yes',
                          onTap: () {
                            HistoryViewController()
                                .deleteNote(noteModel: entry)
                                .then((_) {
                              CustomSnackBar(
                                SnackBarConfig(
                                  titleString1: 'Note deleted!',
                                  leadingIconData1:
                                      FontAwesomeIcons.solidCircleCheck,
                                ),
                              ).showSnackBar(context, ref);
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
                    ),
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
