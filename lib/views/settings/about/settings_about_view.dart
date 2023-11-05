import 'package:flutter/material.dart' hide AppBar, ListTile, PageController;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../utils/constants.dart';
import '../../../widgets/app_bar.dart';
import '../../blueprint/blueprint_view.dart';
import 'widgets/author_tile.dart';
import 'widgets/open_source_licenses_tile.dart';
import 'widgets/privacy_policy_tile.dart';

class SettingsAboutView extends ConsumerWidget {
  const SettingsAboutView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Widget> pageWidgets = [
      // custom list tile for licenses
      const AuthorTile(),
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
      body: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: SingleChildScrollView(
          clipBehavior: Clip.hardEdge,
          child: Wrap(
            spacing: gap,
            runSpacing: gap,
            children: pageWidgets,
          ),
        ),
      ),
    );
  }
}
