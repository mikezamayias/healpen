import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../providers/settings_providers.dart';
import '../../../../widgets/custom_list_tile.dart';

class PrivacyPolicyTile extends ConsumerWidget {
  const PrivacyPolicyTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomListTile(
      useSmallerNavigationSetting:
          !ref.watch(navigationSmallerNavigationElementsProvider),
      enableExplanationWrapper: false,
      titleString: 'Privacy Policy',
      explanationString: 'View the privacy policy for this app.',
      leadingIconData: FontAwesomeIcons.userShield,
      onTap: () {},
    );
  }
}
