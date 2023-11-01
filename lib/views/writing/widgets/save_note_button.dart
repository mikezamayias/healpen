import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../controllers/settings/preferences_controller.dart';
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
    final smallNavigationElements =
        ref.watch(navigationSmallerNavigationElementsProvider);
    return CustomListTile(
      cornerRadius: radius - gap,
      leadingIconData: FontAwesomeIcons.solidFloppyDisk,
      contentPadding:
          smallNavigationElements ? EdgeInsets.zero : EdgeInsets.all(gap),
      onTap: state.content.isNotEmpty
          ? () {
              CustomSnackBar(
                SnackBarConfig(
                  vibrate: PreferencesController
                      .navigationEnableHapticFeedback.value,
                  titleString1: 'Saving note...',
                  leadingIconData1: FontAwesomeIcons.solidFloppyDisk,
                  trailingWidgets1: [
                    CustomListTile(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: gap * 2,
                        vertical: gap,
                      ),
                      cornerRadius: radius - gap,
                      responsiveWidth: true,
                      backgroundColor:
                          context.theme.colorScheme.primaryContainer,
                      textColor: context.theme.colorScheme.onPrimaryContainer,
                      onTap: scaffoldMessengerKey
                          .currentState!.removeCurrentSnackBar,
                      titleString: 'Cancel',
                      leadingIconData: FontAwesomeIcons.xmark,
                    ),
                  ],
                  actionAfterSnackBar1: writingController.handleSaveNote,
                ),
              ).showSnackBar(context);
            }
          : null,
      backgroundColor: state.content.isEmpty
          ? smallNavigationElements
              ? context.theme.colorScheme.background
              : context.theme.colorScheme.outline
          : smallNavigationElements
              ? context.theme.colorScheme.surface
              : context.theme.colorScheme.primary,
      textColor: state.content.isEmpty
          ? smallNavigationElements
              ? context.theme.colorScheme.outline
              : context.theme.colorScheme.background
          : smallNavigationElements
              ? context.theme.colorScheme.primary
              : context.theme.colorScheme.onPrimary,
      responsiveWidth: true,
      title: Text(
        'Save',
        style: context.theme.textTheme.titleLarge!.copyWith(
          color: state.content.isEmpty
              ? smallNavigationElements
                  ? context.theme.colorScheme.outline
                  : context.theme.colorScheme.background
              : smallNavigationElements
                  ? context.theme.colorScheme.primary
                  : context.theme.colorScheme.onPrimary,
        ),
      ),
    );
  }
}
