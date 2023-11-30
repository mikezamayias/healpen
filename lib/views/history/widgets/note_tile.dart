import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../../../controllers/history_view_controller.dart';
import '../../../controllers/settings/preferences_controller.dart';
import '../../../models/analysis/analysis_model.dart';
import '../../../route_controller.dart';
import '../../../utils/constants.dart';
import '../../../utils/helper_functions.dart';
import '../../../utils/show_healpen_dialog.dart';
import '../../../widgets/custom_dialog.dart';
import '../../../widgets/custom_list_tile.dart';

class NoteTile extends ConsumerWidget {
  const NoteTile({
    super.key,
    required this.analysisModel,
  });

  final AnalysisModel analysisModel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Color shapeColor =
        getShapeColorOnSentiment(context.theme, analysisModel.score);
    Color textColor =
        getTextColorOnSentiment(context.theme, analysisModel.score);
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius - gap),
      child: IntrinsicWidth(
        child: Slidable(
          key: ValueKey(analysisModel.timestamp.toString()),
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
                                .deleteNote(timestamp: analysisModel.timestamp);
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
          child: CustomListTile(
            useSmallerNavigationSetting: false,
            textColor: textColor,
            backgroundColor: shapeColor,
            cornerRadius: radius - gap,
            explanationString: DateFormat('HH:mm').format(
              DateTime.fromMillisecondsSinceEpoch(analysisModel.timestamp),
            ),
            title: Text(
              analysisModel.content,
              style: context.theme.textTheme.bodyLarge!.copyWith(
                overflow: TextOverflow.ellipsis,
                color: textColor,
              ),
              maxLines: 3,
            ),
            onTap: () {
              context.navigator.pushNamed(
                RouterController.noteViewRoute.route,
                arguments: (analysisModel: analysisModel),
              );
            },
          ),
        ),
      ),
    );
  }
}
