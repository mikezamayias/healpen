// enable_analytics_tile.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../controllers/settings/firestore_preferences_controller.dart';
import '../../../../controllers/settings/preferences_controller.dart';
import '../../../../providers/settings_providers.dart';
import '../../../../utils/helper_functions.dart';
import '../../../../utils/logger.dart';
import '../../../../widgets/custom_list_tile.dart';

class EnableAnalyticsTile extends ConsumerWidget {
  const EnableAnalyticsTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enableInformatoryText = ref.watch(navigationShowInfoProvider);
    return CustomListTile(
      useSmallerNavigationSetting:
          !ref.watch(navigationSmallerNavigationElementsProvider),
      enableExplanationWrapper:
          !ref.watch(navigationSmallerNavigationElementsProvider),
      titleString: 'Enable Analytics',
      explanationString: enableInformatoryText
          ? 'Allow anonymous analytics and crash data to be sent'
          : null,
      trailing: Switch(
        value: ref.watch(accountAnalyticsEnabledProvider),
        onChanged: (value) async {
          vibrate(ref.watch(navigationEnableHapticFeedbackProvider), () async {
            ref.read(accountAnalyticsEnabledProvider.notifier).state = value;
            await FirestorePreferencesController.instance.savePreference(
              PreferencesController.accountAnalyticsEnabled.withValue(value),
            );
            logger.i('${ref.watch(accountAnalyticsEnabledProvider)}');
          });
        },
      ),
    );
  }
}
