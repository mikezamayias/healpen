import 'package:flutter/material.dart' hide AppBar, ListTile, PageController;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../utils/constants.dart';
import '../../../providers/settings_providers.dart';
import '../../../utils/helper_functions.dart';
import '../../../widgets/app_bar.dart';
import '../../../widgets/custom_list_tile.dart';
import '../../blueprint/blueprint_view.dart';
import '../../simple/simple_blueprint_view.dart';
import '../../simple/widgets/simple_app_bar.dart';
import '../licenses/settings_licenses_view.dart';

class AboutTileModel {
  AboutTileModel({
    required this.title,
    required this.description,
    required this.onTap,
    required this.leadingIconData,
  });

  final String title;
  final String description;
  final void Function()? onTap;
  final IconData leadingIconData;
}

class SettingsAboutView extends ConsumerStatefulWidget {
  const SettingsAboutView({super.key});

  @override
  ConsumerState<SettingsAboutView> createState() => _SettingsAboutViewState();
}

class _SettingsAboutViewState extends ConsumerState<SettingsAboutView> {
  @override
  Widget build(BuildContext context) {
    final aboutTileModels = <AboutTileModel>[
      AboutTileModel(
        title: 'Mike Zamayias',
        description: 'Visit the developer\'s personal website.',
        onTap: () {
          launchUrl(
            Uri.https('mikezamayias.com'),
            mode: LaunchMode.externalApplication,
          );
        },
        leadingIconData: FontAwesomeIcons.laptopCode,
      ),
      AboutTileModel(
        title: 'Terms and Conditions',
        description: 'View the terms and conditions for this app.',
        onTap: () {
          launchUrl(
            Uri.https(
              'iubenda.com',
              'terms-and-conditions/29795832',
            ),
            mode: LaunchMode.externalApplication,
          );
        },
        leadingIconData: FontAwesomeIcons.fileContract,
      ),
      AboutTileModel(
        title: 'Privacy Policy',
        description: 'View the privacy policy for this app.',
        onTap: () {
          launchUrl(
            Uri.https(
              'iubenda.com',
              'privacy-policy/29795832',
            ),
            mode: LaunchMode.externalApplication,
          );
        },
        leadingIconData: FontAwesomeIcons.userShield,
      ),
      AboutTileModel(
        title: 'Open Source Licenses',
        description: 'View the licenses of the open source packages used.',
        onTap: () {
          pushWithAnimation(
            context: context,
            widget: const SettingsLicensesView(),
            dataCallback: null,
          );
        },
        leadingIconData: FontAwesomeIcons.code,
      ),
    ];

    return ref.watch(navigationSimpleUIProvider)
        ? SimpleBlueprintView(
            simpleAppBar: const SimpleAppBar(
              appBarTitleString: 'About',
            ),
            body: _buildBody(aboutTileModels),
          )
        : BlueprintView(
            appBar: const AppBar(
              automaticallyImplyLeading: true,
              pathNames: [
                'Settings',
                'About',
              ],
            ),
            body: _buildBody(aboutTileModels),
          );
  }

  bool get _useSmallerNavigationElements =>
      ref.watch(navigationSmallerNavigationElementsProvider);

  bool get _showInfo => ref.watch(navigationShowInfoProvider);

  Widget _buildBody(List<AboutTileModel> models) {
    return Wrap(
      spacing: gap,
      runSpacing: gap,
      children: models.map(_buildTile).toList(),
    );
  }

  Widget _buildTile(AboutTileModel tileModel) {
    return CustomListTile(
      useSmallerNavigationSetting: !_useSmallerNavigationElements,
      enableExplanationWrapper: !_useSmallerNavigationElements,
      titleString: tileModel.title,
      explanationString: _showInfo ? tileModel.description : null,
      onTap: tileModel.onTap,
      leadingIconData: tileModel.leadingIconData,
    );
  }
}
