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
      'Profile': const SettingsAppView(),
      'Notification': const SettingsAppView(),
      'Writing': const SettingsAppView(),
      'Data & Privacy': const SettingsAppView(),
      'Help & Support': const SettingsAppView(),
      'About': const SettingsAppView(),
    };

    return BlueprintView(
      appBar: const AppBar(
        pathNames: ['Personalize your experience'],
      ),
      body: ListView.separated(
        clipBehavior: Clip.none,
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemBuilder: (_, int index) => CustomListTile(
          titleString: pageWidgets.keys.elementAt(index),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => pageWidgets.values.elementAt(index),
              ),
            );
          },
        ),
        separatorBuilder: (_, __) => SizedBox(height: gap),
        itemCount: pageWidgets.length,
      ),
    );
  }
}
