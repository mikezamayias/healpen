import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../controllers/settings/preferences_controller.dart';
import '../../../../providers/settings_providers.dart';
import '../../widgets/switch_settings_tile.dart';

class ShowAppBarTile extends ConsumerWidget {
  const ShowAppBarTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SwitchSettingsTile(
      titleString: 'Enable app bar on main pages',
      explanationString:
          'Displays the app bar of the current page, making it easier to '
          'determine which main page you are currently on. If disabled, this '
          'will create more space for additional information.',
      stateProvider: navigationShowAppBarProvider,
      preferenceModel: PreferencesController.navigationShowAppBar,
      checkForSimpleUI: true,
    );
  }
}
