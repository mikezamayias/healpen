import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../controllers/writing_controller.dart';
import '../../../providers/settings_providers.dart';
import '../../../utils/constants.dart';
import '../../../widgets/custom_list_tile.dart';
import '../../../widgets/custom_snack_bar.dart';

class SaveNoteButton extends ConsumerWidget {
  const SaveNoteButton({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(writingControllerProvider);
    final writingController = ref.watch(writingControllerProvider.notifier);
    return CustomListTile(
      useSmallerNavigationSetting: false,
      cornerRadius: ref.watch(navigationSmallerNavigationElementsProvider)
          ? radius
          : radius - gap,
      leadingIconData: FontAwesomeIcons.solidFloppyDisk,
      contentPadding: EdgeInsets.symmetric(
        horizontal: 2 * gap,
        vertical: gap,
      ),
      onTap: state.content.isNotEmpty
          ? () {
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
                      onTap: scaffoldMessengerKey
                          .currentState!.removeCurrentSnackBar,
                    ),
                  ],
                  // actionAfterSnackBar1: writingController.handleSaveNote,
                  actionAfterSnackBar1: () {
                    return Future.delayed(1.minutes);
                  },
                ),
              ).showSnackBar(context);
            }
          : null,
      backgroundColor: state.content.isEmpty
          ? context.theme.colorScheme.outline
          : context.theme.colorScheme.primary,
      textColor: state.content.isEmpty
          ? context.theme.colorScheme.surface
          : context.theme.colorScheme.onPrimary,
      responsiveWidth: true,
      titleString: 'Save',
    );
  }
}
