import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../controllers/settings/preferences_controller.dart';
import '../../../../providers/settings_providers.dart';
import '../../widgets/switch_settings_tile.dart';

class SmallerNavigationElementsTile extends ConsumerWidget {
  const SmallerNavigationElementsTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SwitchSettingsTile(
      titleString: 'Enable smaller buttons and menus',
      explanationString: 'Shows smaller buttons and menus. '
          'This is useful for devices with smaller screens.',
      stateProvider: navigationSmallerNavigationElementsProvider,
      preferenceModel:
          PreferencesController.navigationSmallerNavigationElements,
    );
  }
}
