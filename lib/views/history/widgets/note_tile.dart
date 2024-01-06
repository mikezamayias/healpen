import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../controllers/emotional_echo_controller.dart';
import '../../../controllers/history_view_controller.dart';
import '../../../extensions/context_extensions.dart';
import '../../../extensions/int_extensions.dart';
import '../../../models/analysis/analysis_model.dart';
import '../../../providers/settings_providers.dart';
import '../../../route_controller.dart';
import '../../../utils/constants.dart';
import '../../../utils/helper_functions.dart';
import '../../../utils/logger.dart';
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
                  final backgroundColor = context.theme.colorScheme.error;
                  final foregroundColor = context.theme.colorScheme.onError;
                  showHealpenDialog<bool>(
                    context: context,
                    customDialog: CustomDialog(
                      titleString: 'Are you sure?',
                      contentString: 'This action cannot be undone.',
                      textColor: backgroundColor,
                      actions: <CustomListTile>[
                        CustomListTile(
                          responsiveWidth: true,
                          titleString: 'Delete note',
                          textColor: foregroundColor,
                          backgroundColor: backgroundColor,
                          cornerRadius: radius - gap,
                          onTap: () {
                            context.navigator.pop(true);
                          },
                        ),
                        CustomListTile(
                          responsiveWidth: true,
                          titleString: 'Cancel',
                          cornerRadius: radius - gap,
                          onTap: () {
                            context.navigator.pop(false);
                          },
                        ),
                      ],
                    ),
                  ).then((bool? value) {
                    logger.i(
                      'Delete note dialog result: $value',
                    );
                    if (value != null && value) {
                      HistoryViewController()
                          .deleteNote(timestamp: analysisModel.timestamp)
                          .then((_) {
                        context.showSuccessSnackBar(
                          message: 'Note deleted',
                        );
                      }).catchError((error) {
                        logger.e(error);
                        context.showErrorSnackBar(
                          message: 'Error while deleting note',
                          explanation: error.toString(),
                        );
                      });
                    }
                  });
                },
              ),
            ],
          ),
          child: CustomListTile(
            useSmallerNavigationSetting: false,
            textColor: textColor,
            backgroundColor: shapeColor,
            cornerRadius: radius - gap,
            padExplanation:
                true == ref.watch(navigationSmallerNavigationElementsProvider),
            explanationString: analysisModel.timestamp.timestampToHHMM(),
            title: Text(
              analysisModel.content,
              style: context.theme.textTheme.bodyLarge!.copyWith(
                overflow: TextOverflow.ellipsis,
                color: textColor,
              ),
              maxLines: 3,
            ),
            onTap: () {
              pushNamedWithAnimation(
                context: context,
                routeName: RouterController.noteViewRoute.route,
                arguments: (analysisModel: analysisModel),
                dataCallback: () {
                  ref
                      .read(EmotionalEchoController.scoreProvider.notifier)
                      .state = analysisModel.score;
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
