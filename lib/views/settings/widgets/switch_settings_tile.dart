import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../controllers/settings/firestore_preferences_controller.dart';
import '../../../models/settings/preference_model.dart';
import '../../../providers/settings_providers.dart';
import '../../../utils/helper_functions.dart';
import '../../../utils/logger.dart';
import '../../../widgets/custom_list_tile.dart';

class SwitchSettingsTile extends ConsumerWidget {
  final String titleString;
  final String explanationString;
  final StateProvider<bool> stateProvider;
  final PreferenceModel preferenceModel;
  final VoidCallback? additionalAction;
  final bool? checkForSimpleUI;

  const SwitchSettingsTile({
    super.key,
    required this.titleString,
    required this.explanationString,
    required this.stateProvider,
    required this.preferenceModel,
    this.additionalAction,
    this.checkForSimpleUI = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomListTile(
      useSmallerNavigationSetting:
          !ref.watch(navigationSmallerNavigationElementsProvider),
      enableExplanationWrapper:
          !ref.watch(navigationSmallerNavigationElementsProvider),
      titleString: titleString,
      explanationString:
          ref.watch(navigationShowInfoProvider) ? explanationString : null,
      trailing: Switch(
        value: ref.watch(stateProvider),
        onChanged: checkForSimpleUI! && ref.watch(navigationSimpleUIProvider)
            ? null
            : (value) {
                vibrate(
                  ref.watch(navigationEnableHapticFeedbackProvider),
                  () async {
                    ref.read(stateProvider.notifier).state = value;
                    await FirestorePreferencesController.instance
                        .savePreference(
                      preferenceModel.withValue(ref.watch(stateProvider)),
                    );
                    logger.i(
                      '${ref.watch(stateProvider)}',
                    );
                    if (additionalAction != null) {
                      additionalAction!();
                    }
                  },
                );
              },
      ),
    );
  }
}
