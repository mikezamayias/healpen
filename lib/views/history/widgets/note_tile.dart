import 'package:flutter/material.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../controllers/history_view_controller.dart';
import '../../../extensions/int_extensions.dart';
import '../../../models/note/note_model.dart';
import '../../../utils/constants.dart';
import '../../../widgets/custom_list_tile.dart';
import '../../../widgets/custom_snack_bar.dart';
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
      borderRadius: BorderRadius.circular(radius - gap),
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
                  final snackBarConfig = SnackBarConfig(
                    titleString1: entry.isPrivate
                        ? 'Mark note as not private?'
                        : 'Mark note as private?',
                    leadingIconData1: entry.isPrivate
                        ? FontAwesomeIcons.lockOpen
                        : FontAwesomeIcons.lock,
                    trailingWidgets1: [
                      IconButton.filledTonal(
                        onPressed: scaffoldMessengerKey
                            .currentState!.hideCurrentSnackBar,
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
                    actionAfterSnackBar1: () =>
                        HistoryViewController().noteTogglePrivate(
                      noteModel: entry,
                    ),
                    titleString2: entry.isPrivate
                        ? 'Note unmarked as private!'
                        : 'Note marked as private!',
                    leadingIconData2: FontAwesomeIcons.solidCircleCheck,
                  );
                  CustomSnackBar(snackBarConfig).showSnackBar(context);
                },
                backgroundColor: context.theme.colorScheme.primary,
                foregroundColor: context.theme.colorScheme.onPrimary,
                icon: entry.isPrivate
                    ? FontAwesomeIcons.lockOpen
                    : FontAwesomeIcons.lock,
                borderRadius: BorderRadius.circular(radius - gap),
              ),
              SizedBox(width: gap),
              SlidableAction(
                onPressed: (context) {
                  final snackBarConfig = SnackBarConfig(
                    titleString1: entry.isFavorite
                        ? 'Mark note as not favorite?'
                        : 'Mark note as favorite?',
                    leadingIconData1: entry.isFavorite
                        ? FontAwesomeIcons.star
                        : FontAwesomeIcons.solidStar,
                    actionAfterSnackBar1: () =>
                        HistoryViewController().noteToggleFavorite(
                      noteModel: entry,
                    ),
                    trailingWidgets1: [
                      IconButton.filledTonal(
                        onPressed: scaffoldMessengerKey
                            .currentState!.hideCurrentSnackBar,
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
                    titleString2: entry.isFavorite
                        ? 'Note unmarked as favorite!'
                        : 'Note marked as favorite!',
                    leadingIconData2: FontAwesomeIcons.solidCircleCheck,
                  );
                  CustomSnackBar(snackBarConfig).showSnackBar(context);
                },
                backgroundColor: context.theme.colorScheme.primary,
                foregroundColor: context.theme.colorScheme.onPrimary,
                icon: entry.isFavorite
                    ? FontAwesomeIcons.star
                    : FontAwesomeIcons.solidStar,
                borderRadius: BorderRadius.circular(radius - gap),
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
                onPressed: (context) {
                  final snackBarConfig = SnackBarConfig(
                    titleString1: 'Delete note?',
                    leadingIconData1: FontAwesomeIcons.trashCan,
                    trailingWidgets1: [
                      IconButton.filledTonal(
                        onPressed: scaffoldMessengerKey
                            .currentState!.hideCurrentSnackBar,
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
                    titleString2: 'Note Deleted!',
                    leadingIconData2: FontAwesomeIcons.solidCircleCheck,
                    actionAfterSnackBar1: () =>
                        HistoryViewController().deleteNote(
                      noteModel: entry,
                    ),
                  );
                  CustomSnackBar(snackBarConfig).showSnackBar(context);
                },
                backgroundColor: context.theme.colorScheme.tertiary,
                foregroundColor: context.theme.colorScheme.onTertiary,
                icon: FontAwesomeIcons.trashCan,
                borderRadius: BorderRadius.circular(radius - gap),
                padding: EdgeInsets.zero,
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              CustomListTile(
                cornerRadius: radius - gap,
                contentPadding: EdgeInsets.all(gap),
                backgroundColor: context.theme.colorScheme.surface,
                textColor: context.theme.colorScheme.onSurface,
                title: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    NoteStatsTile(
                      statsTitle: 'Date and Time Created',
                      statsValue: entry.timestamp.timestampFormat(),
                    ),
                    NoteStatsTile(
                      statsTitle: 'Content',
                      statsValue: entry.content,
                    ),
                  ],
                ),
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
