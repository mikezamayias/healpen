// enable_analytics_tile.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../controllers/settings/preferences_controller.dart';
import '../../../../providers/settings_providers.dart';
import '../../widgets/switch_settings_tile.dart';

class EnableAnalyticsTile extends ConsumerWidget {
  const EnableAnalyticsTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SwitchSettingsTile(
      titleString: 'Enable Analytics',
      explanationString: 'Allow anonymous analytics and crash data to be sent',
      stateProvider: accountAnalyticsEnabledProvider,
      preferenceModel: PreferencesController.accountAnalyticsEnabled,
    );
  }
}
