import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../controllers/writing_controller.dart';
import '../../../utils/constants.dart';
import '../../../widgets/custom_dialog.dart';
import '../../../widgets/custom_list_tile.dart';

class WritingCheckBox extends ConsumerWidget {
  const WritingCheckBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomListTile(
      cornerRadius: radius - gap,
      contentPadding: EdgeInsets.symmetric(horizontal: gap),
      backgroundColor: context.theme.colorScheme.surface,
      responsiveWidth: true,
      leadingIconData: FontAwesomeIcons.circleInfo,
      leadingOnTap: () {
        showDialog(
          context: context,
          barrierDismissible: false,
          barrierColor: context.theme.colorScheme.background.withOpacity(0.8),
          builder: (BuildContext context) {
            return CustomDialog(
              titleString: 'Private note',
              contentString:
                  'A private note won\'t be used in analysis and will only be visible in History.',
              actions: [
                CustomListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: gap * 2),
                  cornerRadius: radius - gap,
                  responsiveWidth: true,
                  titleString: 'Okay',
                  onTap: context.navigator.pop,
                )
              ],
            );
          },
        );
      },
      titleString: 'Private note',
      trailingIconData: ref.watch(writingControllerProvider).isPrivate
          ? FontAwesomeIcons.solidSquareCheck
          : FontAwesomeIcons.square,
      trailingOnTap: () {
        HapticFeedback.mediumImpact();
        ref
            .watch(writingControllerProvider.notifier)
            .updatePrivate(!ref.watch(writingControllerProvider).isPrivate);
      },
    );
  }
}
