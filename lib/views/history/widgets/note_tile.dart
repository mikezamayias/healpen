import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../controllers/history_view_controller.dart';
import '../../../models/note/note_model.dart';
import '../../../utils/constants.dart';
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
                        ? 'Note marked as not private!'
                        : 'Note marked as private!',
                    leadingIconData2: FontAwesomeIcons.solidCircleCheck,
                  );
                  CustomSnackBar(snackBarConfig).showSnackBar(context, ref);
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
                  CustomSnackBar(snackBarConfig).showSnackBar(context, ref);
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
                  CustomSnackBar(snackBarConfig).showSnackBar(context, ref);
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
            responsiveWidth: true,
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
