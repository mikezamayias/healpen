import 'package:flutter/material.dart' hide AppBar, ListTile, PageController;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../controllers/settings/firestore_preferences_controller.dart';
import '../../../extensions/widget_extensions.dart';
import '../../../models/settings/preference_model.dart';
import '../../../utils/constants.dart';
import '../../../widgets/app_bar.dart';
import '../../blueprint/blueprint_view.dart';
import 'widgets/edit_email_tile.dart';
import 'widgets/edit_name_tile.dart';
import 'widgets/enable_analytics_tile.dart';
import 'widgets/save_settings_to_cloud_tile.dart';
import 'widgets/sign_out_tile.dart';

class SettingsAccountView extends ConsumerWidget {
  const SettingsAccountView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Widget body = StreamBuilder<List<PreferenceModel>>(
      stream: FirestorePreferencesController().getPreferences(),
      builder: (
        BuildContext context,
        AsyncSnapshot<List<PreferenceModel>> snapshot,
      ) {
        List<Widget> pageWidgets = [
          const EditNameTile(),
          const EnableAnalyticsTile(),

          if (snapshot.hasData && snapshot.data!.isEmpty)
            const SaveSettingsToCloudTile(),
          const EditEmailTile(),
          const SignOutTile(),
          // const DeleteAccountTile(),
        ].animateWidgetList();
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: pageWidgets,
        );
      },
    );
    return BlueprintView(
      appBar: const AppBar(
        automaticallyImplyLeading: true,
        pathNames: ['Settings', 'Account'],
      ),
      body: body,
    );
  }
}
