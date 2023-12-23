import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../providers/settings_providers.dart';
import '../../../../widgets/custom_list_tile.dart';

class TermsOfServiceTile extends ConsumerStatefulWidget {
  const TermsOfServiceTile({super.key});

  @override
  ConsumerState<TermsOfServiceTile> createState() => _TermsOfServiceTileState();
}

class _TermsOfServiceTileState extends ConsumerState<TermsOfServiceTile> {
  @override
  Widget build(BuildContext context) {
    return CustomListTile(
      useSmallerNavigationSetting: !useSmallerNavigationElements,
      titleString: 'Terms and Conditions',
      explanationString:
          showInfo ? 'View the terms and conditions for this app.' : null,
      leadingIconData: FontAwesomeIcons.fileContract,
      onTap: () {
        launchUrl(
          Uri.https(
            'iubenda.com',
            'terms-and-conditions/29795832',
          ),
          mode: LaunchMode.externalApplication,
        );
      },
    );
  }

  bool get useSmallerNavigationElements =>
      ref.watch(navigationSmallerNavigationElementsProvider);
  bool get showInfo => ref.watch(navigationShowInfoProvider);
}
