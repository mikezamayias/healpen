import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../controllers/settings/preferences_controller.dart';
import '../../../../providers/settings_providers.dart';
import '../../widgets/switch_settings_tile.dart';

class ColorizeOnSentimentTile extends ConsumerWidget {
  const ColorizeOnSentimentTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SwitchSettingsTile(
      titleString: 'Colorize app based on sentiment',
      explanationString:
          'Changes the color of the app based on the overall sentiment.',
      stateProvider: themeColorizeOnSentimentProvider,
      preferenceModel: PreferencesController.themeColorizeOnSentiment,
    );
  }
}
