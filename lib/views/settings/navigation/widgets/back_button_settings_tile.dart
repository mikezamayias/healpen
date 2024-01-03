import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../controllers/settings/preferences_controller.dart';
import '../../../../providers/settings_providers.dart';
import '../../widgets/switch_settings_tile.dart';

class BackButtonSettingsTile extends ConsumerWidget {
  const BackButtonSettingsTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SwitchSettingsTile(
      titleString: 'Enable back button in app bar',
      explanationString: 'Shows a back button at the top of the screen, making '
          'it simpler to return to previous pages.',
      stateProvider: navigationShowBackButtonProvider,
      preferenceModel: PreferencesController.navigationShowBackButton,
    );
  }
}
