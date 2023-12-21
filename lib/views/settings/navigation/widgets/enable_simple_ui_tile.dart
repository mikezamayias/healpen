import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../controllers/settings/preferences_controller.dart';
import '../../../../providers/settings_providers.dart';
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
    );
  }
}
