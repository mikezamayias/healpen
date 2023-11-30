import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../controllers/settings/firestore_preferences_controller.dart';
import '../../../../controllers/settings/preferences_controller.dart';
import '../../../../providers/settings_providers.dart';
import '../../../../utils/helper_functions.dart';
import '../../../../widgets/custom_list_tile.dart';

class ColorizeOnSentimentTile extends ConsumerWidget {
  const ColorizeOnSentimentTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enableInformatoryText = ref.watch(navigationShowInfoProvider);
    return CustomListTile(
      useSmallerNavigationSetting:
          !ref.watch(navigationSmallerNavigationElementsProvider),
      enableExplanationWrapper:
          !ref.watch(navigationSmallerNavigationElementsProvider),
      titleString: 'Colorize elements based on sentiment',
      explanationString: enableInformatoryText
          ? 'Changes the color of the app based on the overall sentiment.'
          : null,
      trailing: Switch(
        value: ref.watch(themeColorizeOnSentimentProvider),
        onChanged: (value) {
          vibrate(
            ref.watch(navigationEnableHapticFeedbackProvider),
            () async {
              ref.read(themeColorizeOnSentimentProvider.notifier).state = value;
              await FirestorePreferencesController.instance.savePreference(
                PreferencesController.themeColorizeOnSentiment.withValue(
                  ref.watch(themeColorizeOnSentimentProvider),
                ),
              );
              log(
                '${ref.watch(themeColorizeOnSentimentProvider)}',
                name: 'SettingsView:UseSentimentColorTile',
              );
              
            },
          );
        },
      ),
    );
  }
}
