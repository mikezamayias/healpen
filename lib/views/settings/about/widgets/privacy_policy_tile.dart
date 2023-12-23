import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../providers/settings_providers.dart';
import '../../../../widgets/custom_list_tile.dart';

class PrivacyPolicyTile extends ConsumerStatefulWidget {
  const PrivacyPolicyTile({super.key});

  @override
  ConsumerState<PrivacyPolicyTile> createState() => _PrivacyPolicyTileState();
}

class _PrivacyPolicyTileState extends ConsumerState<PrivacyPolicyTile> {
  @override
  Widget build(BuildContext context) {
    return CustomListTile(
      useSmallerNavigationSetting: !useSmallerNavigationElements,
      titleString: 'Privacy Policy',
      explanationString:
          showInfo ? 'View the privacy policy for this app.' : null,
      leadingIconData: FontAwesomeIcons.userShield,
      onTap: () {
        launchUrl(
          Uri.https(
            'iubenda.com',
            'privacy-policy/29795832',
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
