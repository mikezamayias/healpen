import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../controllers/settings/preferences_controller.dart';
import '../../../controllers/writing_controller.dart';
import '../../../providers/settings_providers.dart';
import '../../../utils/constants.dart';
import '../../../utils/helper_functions.dart';
import '../../../utils/show_healpen_dialog.dart';
import '../../../widgets/custom_dialog.dart';
import '../../../widgets/custom_list_tile.dart';

class PrivateNoteCheckBox extends ConsumerWidget {
  const PrivateNoteCheckBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomListTile(
      cornerRadius: radius - gap,
      contentPadding: EdgeInsets.all(gap),
      backgroundColor: context.theme.colorScheme.surface,
      responsiveWidth: true,
      showcaseLeadingIcon: ref.watch(writingShakePrivateNoteInfoProvider),
      leadingIconData: FontAwesomeIcons.circleInfo,
      leadingOnTap: () {
        vibrate(ref.watch(navigationReduceHapticFeedbackProvider), () {
          ref.watch(writingShakePrivateNoteInfoProvider.notifier).state = false;
          PreferencesController.shakePrivateNoteInfo
              .write(ref.watch(writingShakePrivateNoteInfoProvider));
          showHealpenDialog(
            context: context,
            doVibrate: ref.watch(navigationReduceHapticFeedbackProvider),
            customDialog: CustomDialog(
              titleString: 'Private note',
              contentString:
                  'A private note won\'t be used in analysis and will only be visible in History.',
              actions: [
                CustomListTile(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: gap * 2,
                    vertical: gap,
                  ),
                  cornerRadius: radius - gap,
                  responsiveWidth: true,
                  titleString: 'Okay',
                  onTap: () {
                    vibrate(
                      ref.watch(navigationReduceHapticFeedbackProvider),
                      () {
                        ref
                            .watch(writingShakePrivateNoteInfoProvider.notifier)
                            .state = false;
                        PreferencesController.shakePrivateNoteInfo.write(
                            ref.watch(writingShakePrivateNoteInfoProvider));
                        context.navigator.pop();
                      },
                    );
                  },
                )
              ],
            ),
          );
        });
      },
      titleString: 'Make private',
      trailingIconData: ref.watch(writingControllerProvider).isPrivate
          ? FontAwesomeIcons.solidSquareCheck
          : FontAwesomeIcons.square,
      trailingOnTap: () {
        vibrate(ref.watch(navigationReduceHapticFeedbackProvider), () {
          ref
              .watch(writingControllerProvider.notifier)
              .updatePrivate(!ref.watch(writingControllerProvider).isPrivate);
        });
      },
    );
  }
}
