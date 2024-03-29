import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../controllers/settings/firestore_preferences_controller.dart';
import '../../../controllers/settings/preferences_controller.dart';
import '../../../controllers/vibrate_controller.dart';
import '../../../controllers/writing_controller.dart';
import '../../../providers/settings_providers.dart';
import '../../../utils/constants.dart';
import '../../../utils/show_healpen_dialog.dart';
import '../../../widgets/custom_dialog.dart';
import '../../../widgets/custom_list_tile.dart';

class PrivateNoteCheckBox extends ConsumerWidget {
  const PrivateNoteCheckBox({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomListTile(
      cornerRadius: radius - gap,
      backgroundColor: context.theme.colorScheme.surface,
      responsiveWidth: true,
      showcaseLeadingIcon: ref.watch(shakePrivateNoteInfoProvider),
      leadingIconData: ref.watch(shakePrivateNoteInfoProvider)
          ? FontAwesomeIcons.circleInfo
          : FontAwesomeIcons.lock,
      leadingOnTap: ref.watch(shakePrivateNoteInfoProvider)
          ? () {
              VibrateController().run(() async {
                ref.watch(shakePrivateNoteInfoProvider.notifier).state = false;
                await FirestorePreferencesController().savePreference(
                  PreferencesController.shakePrivateNoteInfo
                      .withValue(ref.watch(shakePrivateNoteInfoProvider)),
                );
                if (context.mounted) {
                  showHealpenDialog(
                    context: context,
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
                          onTap: () async {
                            ref
                                .watch(shakePrivateNoteInfoProvider.notifier)
                                .state = false;
                            await FirestorePreferencesController()
                                .savePreference(
                              PreferencesController.shakePrivateNoteInfo
                                  .withValue(
                                      ref.watch(shakePrivateNoteInfoProvider)),
                            );
                            if (context.mounted) {
                              context.navigator.pop();
                            }
                          },
                        )
                      ],
                    ),
                  );
                }
              });
            }
          : null,
      titleString: 'Private note',
      trailingIconData: ref.watch(writingControllerProvider).isPrivate
          ? FontAwesomeIcons.solidSquareCheck
          : FontAwesomeIcons.square,
      trailingOnTap: () {
        VibrateController().run(() {
          ref
              .watch(writingControllerProvider.notifier)
              .updatePrivate(!ref.watch(writingControllerProvider).isPrivate);
        });
      },
    );
  }
}
