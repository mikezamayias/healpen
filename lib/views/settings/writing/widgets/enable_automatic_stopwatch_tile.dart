import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../controllers/settings/preferences_controller.dart';
import '../../../../providers/settings_providers.dart';
import '../../widgets/switch_settings_tile.dart';

class EnableAutomaticStopwatchTile extends ConsumerWidget {
  const EnableAutomaticStopwatchTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SwitchSettingsTile(
      titleString: 'Enable automatic stopwatch',
      explanationString:
          'Pauses the stopwatch when you stop typing and resets it when you clear all text.',
      stateProvider: writingAutomaticStopwatchProvider,
      preferenceModel: PreferencesController.writingAutomaticStopwatch,
    );
  }
}
