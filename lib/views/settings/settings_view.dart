import 'package:flutter/material.dart' hide AppBar, ListTile, PageController;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../utils/constants.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/custom_list_tile.dart';
import '../blueprint/blueprint_view.dart';
import 'account/settings_account_view.dart';
import 'app/settings_app_view.dart';

class SettingsView extends ConsumerWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Map<String, (Widget, IconData)> pageWidgets = {
      'Theme': (
        const SettingsAppView(),
        FontAwesomeIcons.palette,
      ),
      'Account': (
        const SettingsAccountView(),
        FontAwesomeIcons.userLarge,
      ),
      'Notification': (
        const Placeholder(),
        FontAwesomeIcons.solidBell,
      ),
      'Writing': (
        const Placeholder(),
        FontAwesomeIcons.pencil,
      ),
      'Data & Privacy': (
        const Placeholder(),
        FontAwesomeIcons.scroll,
      ),
      'Help & Support': (
        const Placeholder(),
        FontAwesomeIcons.solidMessage,
      ),
      'About': (
        const Placeholder(),
        FontAwesomeIcons.circleInfo,
      ),
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
            if (pageWidgets[title]!.$1 is! Placeholder)
              CustomListTile(
                responsiveWidth: true,
                leadingIconData: pageWidgets[title]!.$2,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: gap * 2,
                  vertical: gap,
                ),
                textColor: context.theme.colorScheme.onPrimary,
                titleString: title,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => pageWidgets[title]!.$1,
                    ),
                  );
                },
              ),
        ],
      ),
    );
  }
}
