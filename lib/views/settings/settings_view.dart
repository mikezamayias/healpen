import 'package:flutter/material.dart' hide AppBar, ListTile, PageController;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utils/constants.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/custom_list_tile.dart';
import '../blueprint/blueprint_view.dart';
import 'app/settings_app_view.dart';

class SettingsView extends ConsumerWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Map<String, Widget> pageWidgets = {
      'App': const SettingsAppView(),
      'Profile': const Placeholder(),
      'Notification': const Placeholder(),
      'Writing': const Placeholder(),
      'Data & Privacy': const Placeholder(),
      'Help & Support': const Placeholder(),
      'About': const Placeholder(),
    };

    return BlueprintView(
      appBar: const AppBar(
        pathNames: ['Personalize your experience'],
      ),
      body: Wrap(
        spacing: gap,
        runSpacing: gap,
        children: [
          for (String title in pageWidgets.keys)
            CustomListTile(
              titleString: title,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => pageWidgets[title]!,
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
