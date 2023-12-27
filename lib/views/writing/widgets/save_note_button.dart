import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../controllers/writing_controller.dart';
import '../../../providers/settings_providers.dart';
import '../../../utils/constants.dart';
import '../../../widgets/custom_snack_bar.dart';
import 'action_button.dart';

class SaveNoteButton extends ConsumerWidget {
  const SaveNoteButton({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(writingControllerProvider);
    final writingController = ref.watch(writingControllerProvider.notifier);
    return ActionButton(
      leadingIconData: FontAwesomeIcons.solidFloppyDisk,
      condition: state.content.isNotEmpty,
      onTap: () {
        CustomSnackBar(
          SnackBarConfig(
            vibrate: ref.watch(navigationEnableHapticFeedbackProvider),
            smallNavigationElements:
                ref.watch(navigationSmallerNavigationElementsProvider),
            titleString1: 'Saving note...',
            leadingIconData1: FontAwesomeIcons.solidFloppyDisk,
            trailingWidgets1: <({
              IconData? iconData,
              String? titleString,
              void Function()? onTap,
            })>[
              (
                iconData: FontAwesomeIcons.xmark,
                titleString: 'Cancel',
                onTap: scaffoldMessengerKey.currentState!.removeCurrentSnackBar,
              ),
            ],
            // actionAfterSnackBar1: () {
            //   return Future.delayed(1.minutes);
            // },
            actionAfterSnackBar1: writingController.handleSaveNote,
          ),
        ).showSnackBar(context);
      },
    );
  }
}
