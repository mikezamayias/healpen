import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../controllers/settings/preferences_controller.dart';
import '../../../../providers/settings_providers.dart';
import '../../widgets/switch_settings_tile.dart';

class HapticFeedbackSettingsTile extends ConsumerWidget {
  const HapticFeedbackSettingsTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SwitchSettingsTile(
      titleString: 'Enable haptic feedback',
      explanationString: 'Enables haptic feedback for buttons and other '
          'elements.',
      stateProvider: navigationEnableHapticFeedbackProvider,
      preferenceModel: PreferencesController.navigationEnableHapticFeedback,
    );
  }
}
