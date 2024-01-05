import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../controllers/settings/firestore_preferences_controller.dart';
import '../../../../controllers/settings/preferences_controller.dart';
import '../../../../models/settings/preference_model.dart';
import '../../../../utils/logger.dart';
import '../../../../widgets/custom_list_tile.dart';

class SaveSettingsToCloudTile extends StatelessWidget {
  const SaveSettingsToCloudTile({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomListTile(
      titleString: 'Save settings to the cloud',
      enableExplanationWrapper: true,
      explanationString:
          'Save your settings to the cloud to sync across devices.',
      leadingIconData: FontAwesomeIcons.cloudArrowUp,
      onTap: () {
        logger.i(
          'SaveSettingsToCloudTile tapped',
        );
        for (({
          PreferenceModel preferenceModel,
          StateProvider provider,
          bool log,
        }) preferencePattern in PreferencesController().preferences) {
          if (preferencePattern.log) {
            logger.i(
              '${preferencePattern.preferenceModel.key}: '
              '${preferencePattern.preferenceModel.value} '
              '(${preferencePattern.preferenceModel.value.runtimeType})',
            );
          }
          FirestorePreferencesController()
              .savePreference(preferencePattern.preferenceModel)
              .then(
                (value) => logger.i(
                  '${preferencePattern.preferenceModel.key} saved to cloud',
                ),
              )
              .onError(
                (error, stackTrace) => logger.e(
                  'Error saving ${preferencePattern.preferenceModel.key} '
                  'to cloud: $error',
                ),
              );
        }
      },
    );
  }
}
