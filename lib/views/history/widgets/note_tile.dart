import 'dart:developer';

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
import '../../../widgets/loading_tile.dart';

class NoteTile extends ConsumerWidget {
  const NoteTile({
    super.key,
    required this.noteModel,
    this.analysisModel,
  });

  final NoteModel noteModel;
  final AnalysisModel? analysisModel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Widget tile = StreamBuilder<({NoteModel note, AnalysisModel? analysis})>(
      stream: FirestoreService().getNoteAndAnalysis(noteModel.timestamp),
      builder: (
        BuildContext context,
        AsyncSnapshot<({NoteModel note, AnalysisModel? analysis})> snapshot,
      ) {
        log(
          '${snapshot.data?.note}',
          name: 'NoteTile:build:StreamBuilder:snapshot.data',
        );
        if (!snapshot.hasData) {
          return const LoadingTile(durationTitle: 'Loading note...');
        }
        final noteModel = snapshot.data!.note;
        final analysisModel = snapshot.data!.analysis;
        return CustomListTile(
          useSmallerNavigationSetting: false,
          textColor: analysisModel != null
              ? getShapeColorOnSentiment(context, analysisModel.score).isDark
                  ? context.theme.colorScheme.onSurface
                  : context.theme.colorScheme.surface
              : null,
          backgroundColor: analysisModel != null
              ? getShapeColorOnSentiment(
                  context,
                  analysisModel.score,
                )
              : null,
          cornerRadius: radius - gap,
          contentPadding: EdgeInsets.all(gap),
          explanationString: DateFormat('HH:mm')
              .format(
                DateTime.fromMillisecondsSinceEpoch(noteModel.timestamp),
              )
              .toString(),
          title: Text(
            noteModel.content,
            style: context.theme.textTheme.bodyLarge!.copyWith(
              overflow: TextOverflow.ellipsis,
              color:
                  getShapeColorOnSentiment(context, analysisModel!.score).isDark
                      ? context.theme.colorScheme.onSurface
                      : context.theme.colorScheme.surface,
            ),
            maxLines: 1,
          ),
          onTap: () {
            context.navigator.pushNamed(
              RouterController.noteViewRoute.route,
              arguments: (
                noteModel: noteModel,
                analysisModel: analysisModel,
              ),
            );
          },
        );
      },
    );
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius - gap),
      child: IntrinsicWidth(
        child: Slidable(
          key: ValueKey(noteModel.timestamp.toString()),
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
                            HistoryViewController()
                                .deleteNote(noteModel: noteModel);
                            Navigator.pop(navigatorKey.currentContext!);
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
                            Navigator.pop(navigatorKey.currentContext!);
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
