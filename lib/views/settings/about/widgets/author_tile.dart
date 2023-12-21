import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../providers/settings_providers.dart';
import '../../../../widgets/custom_list_tile.dart';

class AuthorTile extends ConsumerWidget {
  const AuthorTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomListTile(
      useSmallerNavigationSetting:
          !ref.watch(navigationSmallerNavigationElementsProvider),
      enableExplanationWrapper: false,
      titleString: 'Mike Zamayias',
      explanationString: 'Visit the developer\'s personal website.',
      leadingIconData: FontAwesomeIcons.laptopCode,
      onTap: () {
        launchUrl(
          Uri.https('mikezamayias.com'),
          mode: LaunchMode.externalApplication,
        );
      },
    );
  }
}
