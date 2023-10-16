import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../../../controllers/history_view_controller.dart';
import '../../../controllers/settings/preferences_controller.dart';
import '../../../models/analysis/analysis_model.dart';
import '../../../models/note/note_model.dart';
import '../../../route_controller.dart';
import '../../../services/firestore_service.dart';
import '../../../utils/constants.dart';
import '../../../utils/helper_functions.dart';
import '../../../utils/show_healpen_dialog.dart';
import '../../../widgets/custom_dialog.dart';
import '../../../widgets/custom_list_tile.dart';

class NoteTile extends ConsumerWidget {
  const NoteTile({
    super.key,
    required this.entry,
  });

  final NoteModel entry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomListTile tile = CustomListTile(
      cornerRadius: radius - gap,
      contentPadding: EdgeInsets.all(gap),
      explanationString: DateFormat('HH:mm')
          .format(DateTime.fromMillisecondsSinceEpoch(entry.timestamp))
          .toString(),
      title: Text(
        entry.content,
        style: context.theme.textTheme.bodyLarge!.copyWith(
          color: context.theme.colorScheme.onPrimary,
          overflow: TextOverflow.ellipsis,
        ),
        maxLines: 1,
      ),
      onTap: () {
        vibrate(
          PreferencesController.navigationEnableHapticFeedback.value,
          () async {
            NoteModel noteEntry = NoteModel.fromJson(
              (await FirestoreService().getNote(entry.timestamp)).data()!,
            );
            AnalysisModel analysisEntry = AnalysisModel.fromJson(
              (await FirestoreService().getAnalysis(entry.timestamp)).data()!,
            );
            if (context.mounted) {
              context.navigator.pushNamed(
                RouterController.noteViewRoute.route,
                arguments: (
                  noteModel: noteEntry,
                  analysisModel: analysisEntry,
                ),
              );
            }
          },
        );
      },
    );
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius - gap),
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
                borderRadius: BorderRadius.circular(radius - gap),
                padding: EdgeInsets.all(gap),
                spacing: gap,
                onPressed: (context) {
                  showHealpenDialog(
                    context: context,
                    doVibrate: PreferencesController
                        .navigationEnableHapticFeedback.value,
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
                          titleString: 'Delete',
                          backgroundColor: context.theme.colorScheme.error,
                          textColor: context.theme.colorScheme.onError,
                          onTap: () {
                            vibrate(
                              PreferencesController
                                  .navigationEnableHapticFeedback.value,
                              () {
                                Navigator.pop(navigatorKey.currentContext!);
                                HistoryViewController()
                                    .deleteNote(noteModel: entry);
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
                          titleString: 'Go back',
                          onTap: () {
                            vibrate(
                              PreferencesController
                                  .navigationEnableHapticFeedback.value,
                              () {
                                Navigator.pop(navigatorKey.currentContext!);
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
          child: tile,
        ),
      ),
    );
  }
}
