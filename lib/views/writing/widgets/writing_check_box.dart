import 'package:flutter/material.dart';
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
      backgroundColor: context.theme.colorScheme.surface,
      responsiveWidth: true,
      leadingIconData: FontAwesomeIcons.circleInfo,
      leadingOnTap: () {
        showDialog(
          context: context,
          barrierDismissible: false,
          barrierColor:
              context.theme.colorScheme.onBackground.withOpacity(0.25),
          builder: (BuildContext context) {
            return CustomDialog(
              titleString: 'Private note',
              contentString:
                  'A private note won\'t be used in analvsis and won\'t be visible anywhere else in the app.',
              actions: [
                CustomListTile(
                  responsiveWidth: true,
                  titleString: 'Okay',
                  onTap: () {
                    Navigator.pop(context);
                  },
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
      trailingOnTap: () => ref
          .watch(writingControllerProvider.notifier)
          .updatePrivate(!ref.watch(writingControllerProvider).isPrivate),
    );
  }
}
