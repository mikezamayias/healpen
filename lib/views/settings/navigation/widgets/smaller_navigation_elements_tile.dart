import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../controllers/settings/firestore_preferences_controller.dart';
import '../../../../controllers/settings/preferences_controller.dart';
import '../../../../providers/settings_providers.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/helper_functions.dart';
import '../../../../widgets/custom_list_tile.dart';

class SmallerNavigationElementsTile extends ConsumerWidget {
  const SmallerNavigationElementsTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomListTile(
      contentPadding: EdgeInsets.all(gap),
      titleString: 'Enable smaller navigation elements',
      explanationString:
          'When enabled, the app will show smaller navigation elements. '
          'This is useful for devices with smaller screens.',
      enableExplanationWrapper: true,
      trailing: Switch(
        value: ref.watch(navigationSmallerNavigationElementsProvider),
        onChanged: (value) {
          vibrate(
            ref.watch(navigationEnableHapticFeedbackProvider),
            () async {
              ref
                  .read(navigationSmallerNavigationElementsProvider.notifier)
                  .state = value;
              await FirestorePreferencesController.instance.savePreference(
                PreferencesController.navigationSmallerNavigationElements
                    .withValue(
                  ref.watch(navigationSmallerNavigationElementsProvider),
                ),
              );
              log(
                '${ref.watch(navigationSmallerNavigationElementsProvider)}',
                name: 'SmallerNavigationElementsTile',
              );
            },
          );
        },
      ),
    );
  }
}
