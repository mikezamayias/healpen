import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../controllers/history_view_controller.dart';
import '../../../extensions/int_extensions.dart';
import '../../../models/note/note_model.dart';
import '../../../utils/constants.dart';
import '../../../utils/helper_functions.dart';
import '../../../widgets/custom_list_tile.dart';
import 'note_stats_title.dart';

class NoteTile extends StatelessWidget {
  const NoteTile({
    super.key,
    required this.entry,
  });

  final NoteModel entry;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: IntrinsicWidth(
        child: Slidable(
          key: ValueKey(entry.timestamp.toString()),
          startActionPane: ActionPane(
            extentRatio: 0.5,
            motion: const ScrollMotion(),
            dragDismissible: false,
            children: [
              SlidableAction(
                onPressed: (context) {
                  doAndShowSnackbar(
                    context,
                    firstDo: HistoryViewController().noteToggleFavorite(
                      noteModel: entry,
                    ),
                    thenDo: [
                      log(
                        'swiped start to end',
                        name: 'HistoryView:NoteTile',
                      ),
                    ],
                    snackBarOptions: entry.isFavorite
                        ? (
                            'Note unmarked as favorite',
                            FontAwesomeIcons.star,
                          )
                        : (
                            'Note marked as favorite',
                            FontAwesomeIcons.solidStar,
                          ),
                  );
                },
                backgroundColor: context.theme.colorScheme.primary,
                foregroundColor: context.theme.colorScheme.onPrimary,
                icon: FontAwesomeIcons.solidStar,
                borderRadius: BorderRadius.circular(radius),
              ),
              SizedBox(width: gap),
              SlidableAction(
                onPressed: (context) {
                  doAndShowSnackbar(
                    context,
                    firstDo: HistoryViewController().noteTogglePrivate(
                      noteModel: entry,
                    ),
                    thenDo: [
                      log(
                        'swiped start to end',
                        name: 'HistoryView:NoteTile',
                      ),
                    ],
                    snackBarOptions: entry.isPrivate
                        ? (
                            'Note unmarked as private',
                            FontAwesomeIcons.lockOpen,
                          )
                        : (
                            'Note marked as private',
                            FontAwesomeIcons.lock,
                          ),
                  );
                },
                backgroundColor: context.theme.colorScheme.primary,
                foregroundColor: context.theme.colorScheme.onPrimary,
                icon: FontAwesomeIcons.lock,
                borderRadius: BorderRadius.circular(radius),
              ),
              SizedBox(width: gap),
            ],
          ),
          endActionPane: ActionPane(
            motion: const ScrollMotion(),
            dragDismissible: true,
            extentRatio: 0.25,
            children: [
              SizedBox(width: gap),
              SlidableAction(
                onPressed: (context) async {
                  final snackBar = SnackBar(
                    behavior: SnackBarBehavior.floating,
                    margin: EdgeInsets.all(gap),
                    padding: EdgeInsets.only(right: gap * 2),
                    duration: 2.seconds,
                    backgroundColor: context.theme.colorScheme.secondary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(radius),
                    ),
                    content: CustomListTile(
                      backgroundColor: context.theme.colorScheme.secondary,
                      textColor: context.theme.colorScheme.onSecondary,
                      titleString: 'Deleting note...',
                      leadingIconData: FontAwesomeIcons.trashCan,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: gap * 2,
                        vertical: gap,
                      ),
                      cornerRadius: radius,
                    ),
                    action: SnackBarAction(
                      label: 'Undo',
                      onPressed: () {},
                    ),
                  );
                  ScaffoldMessenger.of(context)
                      .showSnackBar(snackBar)
                      .closed
                      .then(
                    (SnackBarClosedReason reason) {
                      if (reason != SnackBarClosedReason.action) {
                        // Only delete the note if the snackbar wasn't closed by an action (like an undo action)
                        HistoryViewController().deleteNote(noteModel: entry);
                      }
                    },
                  );
                },
                // onPressed: (context) {
                //   doAndShowSnackbar(
                //     context,
                //     firstDo: HistoryViewController().deleteNote(
                //       noteModel: entry,
                //     ),
                //     thenDo: [
                //       log(
                //         'swiped end to start',
                //         name: 'HistoryView:NoteTile',
                //       ),
                //     ],
                //     snackBarOptions: (
                //       'Note deleted successfully!',
                //       FontAwesomeIcons.trashCan,
                //     ),
                //   );
                // },
                backgroundColor: context.theme.colorScheme.tertiary,
                foregroundColor: context.theme.colorScheme.onTertiary,
                icon: FontAwesomeIcons.trashCan,
                borderRadius: BorderRadius.circular(radius),
                padding: EdgeInsets.zero,
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              CustomListTile(
                contentPadding: EdgeInsets.all(gap),
                backgroundColor: context.theme.colorScheme.surface,
                textColor: context.theme.colorScheme.onSurface,
                title: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      entry.timestamp.timestampFormat(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.theme.textTheme.titleLarge!.copyWith(
                        color: context.theme.colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      entry.content,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: context.theme.textTheme.titleSmall!.copyWith(
                        color: context.theme.colorScheme.onSurface,
                      ),
                    ),
                    NoteStatsTile(
                      statsTitle: 'Duration',
                      statsValue: entry.duration.writingDurationFormat(),
                    ),
                    NoteStatsTile(
                      statsTitle: 'Word Count',
                      statsValue: entry.wordCount.toString(),
                    ),
                  ],
                ),
                // leadingIconData:
                //     entry.isPrivate ? FontAwesomeIcons.lock : FontAwesomeIcons.lockOpen,
                onTap: () => context.navigator.pushNamed(
                  '/note',
                  arguments: entry,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(gap),
                child: Column(
                  children: [
                    FaIcon(
                      entry.isPrivate
                          ? FontAwesomeIcons.lock
                          : FontAwesomeIcons.lockOpen,
                      size: context.theme.textTheme.titleLarge!.fontSize,
                      color: context.theme.colorScheme.secondary,
                    ),
                    SizedBox(height: gap),
                    FaIcon(
                      entry.isFavorite
                          ? FontAwesomeIcons.solidStar
                          : FontAwesomeIcons.star,
                      size: context.theme.textTheme.titleLarge!.fontSize,
                      color: context.theme.colorScheme.secondary,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
