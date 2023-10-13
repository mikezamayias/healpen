import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:riverpod/src/state_provider.dart';

import '../../../../controllers/settings/preferences_controller.dart';
import '../../../../enums/app_theming.dart';
import '../../../../models/settings/preference_model.dart';
import '../../../../services/firestore_service.dart';
import '../../../../utils/constants.dart';
import '../../../../widgets/custom_list_tile.dart';

class SaveSettingsToCloudTile extends StatelessWidget {
  const SaveSettingsToCloudTile({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomListTile(
      contentPadding: EdgeInsets.all(gap),
      titleString: 'Save settings to the cloud',
      enableExplanationWrapper: true,
      explanationString:
          'Save your settings to the cloud to sync across devices.',
      leadingIconData: FontAwesomeIcons.cloudArrowUp,
      onTap: () {
        log(
          'SaveSettingsToCloudTile tapped',
          name: 'SaveSettingsToCloudTile',
        );
        for (({
          PreferenceModel preferenceModel,
          StateProvider provider
        }) preferencePattern in PreferencesController().preferences) {
          log(
            '${preferencePattern.preferenceModel.key}: '
            '${preferencePattern.preferenceModel.value} '
            '(${preferencePattern.preferenceModel.value.runtimeType})',
            name: 'preferencePattern',
          );
          FirestoreService.preferencesCollectionReference()
              .update({
                preferencePattern.preferenceModel.key: [
                  ThemeColor,
                  ThemeAppearance
                ].contains(preferencePattern.preferenceModel.value.runtimeType)
                    ? preferencePattern.preferenceModel.value.toString()
                    : preferencePattern.preferenceModel.value,
              })
              .then(
                (value) => log(
                  '${preferencePattern.preferenceModel.key} saved to cloud',
                  name: 'SaveSettingsToCloudTile',
                ),
              )
              .onError(
                (error, stackTrace) => log(
                  'Error saving ${preferencePattern.preferenceModel.key} '
                  'to cloud: $error',
                  name: 'SaveSettingsToCloudTile',
                ),
              );
        }
      },
    );
  }
}
