import 'package:flutter/material.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../controllers/history_view_controller.dart';
import '../../../extensions/int_extensions.dart';
import '../../../models/note/note_model.dart';
import '../../../models/snack_bar_options.dart';
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
                  CustomSnackBar.doActionAndShowSnackBar(
                    doAction: () => HistoryViewController().noteTogglePrivate(
                      noteModel: entry,
                    ),
                    options: entry.isPrivate
                        ? SnackBarOptions(
                            message: 'Marking note as not private...',
                            icon: FontAwesomeIcons.lockOpen,
                          )
                        : SnackBarOptions(
                            message: 'Marking note as private...',
                            icon: FontAwesomeIcons.lock,
                          ),
                    afterSnackBar: () {
                      CustomSnackBar.showSnackBar(
                        message: entry.isPrivate
                            ? 'Note unmarked as private!'
                            : 'Note marked as private!',
                        icon: FontAwesomeIcons.solidCircleCheck,
                      );
                    },
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
                  CustomSnackBar.doActionAndShowSnackBar(
                    doAction: () => HistoryViewController().noteToggleFavorite(
                      noteModel: entry,
                    ),
                    options: entry.isFavorite
                        ? SnackBarOptions(
                            message: 'Marking note as not favorite...',
                            icon: FontAwesomeIcons.star,
                          )
                        : SnackBarOptions(
                            message: 'Marking note as favorite...',
                            icon: FontAwesomeIcons.solidStar,
                          ),
                    afterSnackBar: () {
                      CustomSnackBar.showSnackBar(
                        message: entry.isFavorite
                            ? 'Note unmarked as favorite!'
                            : 'Note marked as favorite!',
                        icon: FontAwesomeIcons.solidCircleCheck,
                      );
                    },
                  );
                },
                backgroundColor: context.theme.colorScheme.primary,
                foregroundColor: context.theme.colorScheme.onPrimary,
                icon: entry.isFavorite
                    ? FontAwesomeIcons.star
                    : FontAwesomeIcons.solidStar,
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
                  CustomSnackBar.doActionAndShowSnackBar(
                    doAction: () => HistoryViewController().deleteNote(
                      noteModel: entry,
                    ),
                    options: SnackBarOptions(
                      message: 'Deleting note...',
                      icon: FontAwesomeIcons.trashCan,
                    ),
                    afterSnackBar: () {
                      CustomSnackBar.showSnackBar(
                        message: 'Note deleted!',
                        icon: FontAwesomeIcons.solidCircleCheck,
                      );
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
