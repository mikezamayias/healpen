import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../providers/settings_providers.dart';
import '../../../../widgets/custom_list_tile.dart';

class TermsOfServiceTile extends ConsumerWidget {
  const TermsOfServiceTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomListTile(
      useSmallerNavigationSetting:
          !ref.watch(navigationSmallerNavigationElementsProvider),
      enableExplanationWrapper: false,
      titleString: 'Terms and Conditions',
      explanationString: 'View the terms and conditions for this app.',
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
}
