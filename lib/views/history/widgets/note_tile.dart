import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../controllers/history_view_controller.dart';
import '../../../models/note/note_model.dart';
import '../../../providers/settings_providers.dart';
import '../../../utils/constants.dart';
import '../../../utils/helper_functions.dart';
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
          endActionPane: ActionPane(
            motion: const ScrollMotion(),
            dragDismissible: true,
            extentRatio: 0.6,
            children: [
              SizedBox(width: gap),
              SlidableAction(
                icon: FontAwesomeIcons.trashCan,
                autoClose: true,
                backgroundColor: context.theme.colorScheme.tertiary,
                foregroundColor: context.theme.colorScheme.onTertiary,
                borderRadius: BorderRadius.circular(radius),
                padding: EdgeInsets.all(gap),
                spacing: gap,
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
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: gap * 2,
                            vertical: gap,
                          ),
                          cornerRadius: radius - gap,
                          responsiveWidth: true,
                          titleString: 'Yes',
                          onTap: () {
                            vibrate(
                              ref.watch(navigationReduceHapticFeedbackProvider),
                              () {
                                navigatorKey.currentState?.pop(true);
                              },
                            );
                          },
                        ),
                        CustomListTile(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: gap * 2,
                            vertical: gap,
                          ),
                          cornerRadius: radius - gap,
                          responsiveWidth: true,
                          titleString: 'No',
                          onTap: () {
                            vibrate(
                              ref.watch(navigationReduceHapticFeedbackProvider),
                              () {
                                navigatorKey.currentState?.pop(false);
                              },
                            );
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
                            vibrate: ref
                                .watch(navigationReduceHapticFeedbackProvider),
                            titleString1: 'Deleting note...',
                            leadingIconData1: FontAwesomeIcons.trashCan,
                            actionAfterSnackBar1: () async =>
                                HistoryViewController()
                                    .deleteNote(noteModel: entry),
                            trailingWidgets1: [
                              CustomListTile(
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: gap * 2,
                                  vertical: gap,
                                ),
                                cornerRadius: radius - gap,
                                responsiveWidth: true,
                                backgroundColor:
                                    context.theme.colorScheme.primaryContainer,
                                textColor: context
                                    .theme.colorScheme.onPrimaryContainer,
                                onTap: () {
                                  vibrate(
                                    ref.watch(
                                        navigationReduceHapticFeedbackProvider),
                                    () {
                                      scaffoldMessengerKey
                                          .currentState!.removeCurrentSnackBar;
                                    },
                                  );
                                },
                                titleString: 'Cancel',
                                leadingIconData: FontAwesomeIcons.xmark,
                              ),
                            ],
                          ),
                        ).showSnackBar(context);
                      }
                    },
                  );
                },
              ),
            ],
          ),
          child: CustomListTile(
            contentPadding: EdgeInsets.symmetric(
              horizontal: gap * 2,
              vertical: gap,
            ),
            title: Text(
              entry.content,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.theme.textTheme.titleMedium!
                  .copyWith(color: context.theme.colorScheme.onPrimary),
            ),
            onTap: () {
              vibrate(
                ref.watch(navigationReduceHapticFeedbackProvider),
                () {
                  context.navigator.pushNamed(
                    '/note',
                    arguments: entry,
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
