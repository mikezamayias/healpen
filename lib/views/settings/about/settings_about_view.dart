import 'package:flutter/material.dart' hide AppBar, ListTile, PageController;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../utils/constants.dart';
import '../../../models/settings/settings_item_model.dart';
import '../../../providers/settings_providers.dart';
import '../../../utils/helper_functions.dart';
import '../../../widgets/app_bar.dart';
import '../../blueprint/blueprint_view.dart';
import '../licenses/settings_licenses_view.dart';
import '../widgets/settings_item_tile.dart';

class SettingsAboutView extends ConsumerStatefulWidget {
  const SettingsAboutView({super.key});

  @override
  ConsumerState<SettingsAboutView> createState() => _SettingsAboutViewState();
}

class _SettingsAboutViewState extends ConsumerState<SettingsAboutView> {
  @override
  Widget build(BuildContext context) {
    final aboutTileModels = <SettingsItemModel>[
      SettingsItemModel(
        title: 'Mike Zamayias',
        description: 'Visit the developer\'s personal website.',
        onTap: (context) {
          launchUrl(
            Uri.https('mikezamayias.com'),
            mode: LaunchMode.externalApplication,
          );
        },
        leadingIconData: FontAwesomeIcons.laptopCode,
      ),
      SettingsItemModel(
        title: 'Terms and Conditions',
        description: 'View the terms and conditions for this app.',
        onTap: (context) {
          launchUrl(
            Uri.https(
              'iubenda.com',
              'terms-and-conditions/29795832',
            ),
            mode: LaunchMode.inAppWebView,
          );
        },
        leadingIconData: FontAwesomeIcons.fileContract,
      ),
      SettingsItemModel(
        title: 'Privacy Policy',
        description: 'View the privacy policy for this app.',
        onTap: (context) {
          launchUrl(
            Uri.https(
              'iubenda.com',
              'privacy-policy/29795832',
            ),
            mode: LaunchMode.inAppWebView,
          );
        },
        leadingIconData: FontAwesomeIcons.userShield,
      ),
      SettingsItemModel(
        title: 'Open Source Licenses',
        description: 'View the licenses of the open source packages used.',
        onTap: (context) {
          pushWithAnimation(
            context: context,
            widget: const SettingsLicensesView(),
            dataCallback: null,
          );
        },
        leadingIconData: FontAwesomeIcons.code,
      ),
    ];

    return BlueprintView(
      appBar: const AppBar(
        automaticallyImplyLeading: true,
        pathNames: [
          'Settings',
          'About',
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: AnimatedContainer(
              duration: standardDuration,
              curve: standardCurve,
              decoration: _useSmallerNavigationElements
                  ? const BoxDecoration()
                  : BoxDecoration(
                      color: theme.colorScheme.surfaceVariant,
                      borderRadius: BorderRadius.circular(radius),
                    ),
              padding: _useSmallerNavigationElements
                  ? EdgeInsets.zero
                  : EdgeInsets.all(gap),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(_dynamicRadius),
                child: SingleChildScrollView(
                  child: Wrap(
                    spacing: gap,
                    runSpacing: gap,
                    children: aboutTileModels
                        .map((element) =>
                            SettingsItemTile(settingsItemModel: element))
                        .toList(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  double get _dynamicRadius => _useSmallerNavigationElements ? radius : gap;

  bool get _useSmallerNavigationElements =>
      ref.watch(navigationSmallerNavigationElementsProvider);
}
