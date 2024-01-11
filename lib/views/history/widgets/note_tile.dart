import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../controllers/emotional_echo_controller.dart';
import '../../../controllers/date_view_controller.dart';
import '../../../extensions/int_extensions.dart';
import '../../../models/note_tile_model.dart';
import '../../../providers/settings_providers.dart';
import '../../../route_controller.dart';
import '../../../utils/constants.dart';
import '../../../utils/helper_functions.dart';
import '../../../widgets/custom_list_tile.dart';

class NoteTile extends ConsumerWidget {
  const NoteTile(
    this.noteTileModel, {
    super.key,
  });

  final NoteTileModel noteTileModel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Color shapeColor = getShapeColorOnSentiment(
      context.theme,
      noteTileModel.analysisModel.score,
    );
    Color textColor = getTextColorOnSentiment(
      context.theme,
      noteTileModel.analysisModel.score,
    );
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: gap),
      child: CustomListTile(
        cornerRadius: ref.watch(navigationSmallerNavigationElementsProvider)
            ? radius
            : radius - gap,
        textColor: textColor,
        backgroundColor: shapeColor,
        title: Text(
          noteTileModel.analysisModel.content,
          style: context.theme.textTheme.bodyLarge!.copyWith(
            overflow: TextOverflow.ellipsis,
            color: textColor,
          ),
          maxLines: 3,
        ),
        explanationString:
            noteTileModel.analysisModel.timestamp.timestampToHHMM(),
        explanationPadding: EdgeInsets.only(bottom: gap, left: gap, right: gap),
        onTap: () {
          pushNamedWithAnimation(
            context: context,
            routeName: RouterController.noteViewRoute.route,
            arguments: (analysisModel: noteTileModel.analysisModel),
            dataCallback: () {
              ref.read(EmotionalEchoController.scoreProvider.notifier).state =
                  noteTileModel.analysisModel.score;
            },
          );
        },
        trailingIconData:
            ref.watch(DateViewController.noteSelectionEnabledProvider)
                ? ref.watch(noteTileModel.isSelectedProvider)
                    ? FontAwesomeIcons.solidSquareCheck
                    : FontAwesomeIcons.square
                : null,
        trailingOnTap:
            ref.watch(DateViewController.noteSelectionEnabledProvider)
                ? () {
                    ref.read(noteTileModel.isSelectedProvider.notifier).state =
                        !ref.read(noteTileModel.isSelectedProvider);
                  }
                : null,
      ),
    );
  }
}
