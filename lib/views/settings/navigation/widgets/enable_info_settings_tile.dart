import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../controllers/settings/preferences_controller.dart';
import '../../../../providers/settings_providers.dart';
import '../../widgets/switch_settings_tile.dart';

class EnableInfoSettingsTile extends ConsumerWidget {
  const EnableInfoSettingsTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SwitchSettingsTile(
      titleString: 'Enable informatory text',
      explanationString: 'Enable the informatory text on below elements to '
          'learn more about them',
      stateProvider: navigationShowInfoProvider,
      preferenceModel: PreferencesController.navigationShowInfo,
    );
  }
}
