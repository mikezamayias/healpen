import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restart_app/restart_app.dart';

import '../../../../controllers/settings/firestore_preferences_controller.dart';
import '../../../../controllers/settings/preferences_controller.dart';
import '../../../../providers/settings_providers.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/helper_functions.dart';
import '../../../../utils/show_healpen_dialog.dart';
import '../../../../widgets/custom_dialog.dart';
import '../../../../widgets/custom_list_tile.dart';
import '../../widgets/switch_settings_tile.dart';

class EnableSimpleUiTile extends ConsumerWidget {
  const EnableSimpleUiTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SwitchSettingsTile(
      titleString: 'Enable simple UI',
      explanationString: 'Enable a simpler UI for the app',
      stateProvider: navigationSimpleUIProvider,
      preferenceModel: PreferencesController.navigationSimpleUI,
      onChanged: (value) {
        vibrate(
          ref.watch(navigationEnableHapticFeedbackProvider),
          () async {
            final result = await showHealpenDialog<bool>(
              context: context,
              // warn the user that the app will restart
              customDialog: CustomDialog(
                titleString: 'Restart required',
                contentString:
                    'The app will restart to apply the changes to the UI.',
                actions: [
                  CustomListTile(
                    cornerRadius: radius - gap,
                    responsiveWidth: true,
                    titleString: 'Okay',
                    onTap: () {
                      Navigator.of(context).pop(true);
                    },
                  ),
                  CustomListTile(
                    cornerRadius: radius - gap,
                    responsiveWidth: true,
                    titleString: 'Cancel',
                    onTap: () {
                      Navigator.of(context).pop(false);
                    },
                  ),
                ],
              ),
            );
            if (result!) {
              ref.read(navigationSimpleUIProvider.notifier).state = value;
              await FirestorePreferencesController.instance.savePreference(
                PreferencesController.navigationSimpleUI
                    .withValue(ref.watch(navigationSimpleUIProvider)),
              );
              Restart.restartApp();
            }
          },
        );
      },
    );
  }
}
