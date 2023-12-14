import 'package:flutter/material.dart' hide AppBar, ListTile, PageController;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../utils/constants.dart';
import '../../../widgets/app_bar.dart';
import '../../blueprint/blueprint_view.dart';
import 'widgets/author_tile.dart';
import 'widgets/open_source_licenses_tile.dart';
import 'widgets/privacy_policy_tile.dart';
import 'widgets/terms_of_service_tile.dart';

class SettingsAboutView extends ConsumerWidget {
  const SettingsAboutView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Widget> pageWidgets = [
      // custom list tile for licenses
      const AuthorTile(),
      const TermsOfServiceTile(),
      const PrivacyPolicyTile(),
      const OpenSourceLicensesTile(),
    ];

    return BlueprintView(
      showAppBar: true,
      appBar: const AppBar(
        automaticallyImplyLeading: true,
        pathNames: [
          'Settings',
          'About',
        ],
      ),
      body: Wrap(
        spacing: gap,
        runSpacing: gap,
        children: pageWidgets,
      ),
    );
    return ref.watch(navigationSimpleUIProvider)
        ? SimpleBlueprintView(
            simpleUiAppBar: const SimpleAppBar(
              appBarTitleString: 'About',
            ),
            body: body,
          )
        : BlueprintView(
            showAppBar: true,
            appBar: const AppBar(
              automaticallyImplyLeading: true,
              pathNames: [
                'Settings',
                'About',
              ],
            ),
            body: body,
          );
  }
}
