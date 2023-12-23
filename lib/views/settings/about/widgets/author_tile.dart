import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../providers/settings_providers.dart';
import '../../../../widgets/custom_list_tile.dart';

class AuthorTile extends ConsumerStatefulWidget {
  const AuthorTile({super.key});

  @override
  ConsumerState<AuthorTile> createState() => _AuthorTileState();
}

class _AuthorTileState extends ConsumerState<AuthorTile> {
  @override
  Widget build(BuildContext context) {
    return CustomListTile(
      useSmallerNavigationSetting: !useSmallerNavigationElements,
      titleString: 'Mike Zamayias',
      explanationString:
          showInfo ? 'Visit the developer\'s personal website.' : null,
      leadingIconData: FontAwesomeIcons.laptopCode,
      onTap: () {
        launchUrl(
          Uri.https('mikezamayias.com'),
          mode: LaunchMode.externalApplication,
        );
      },
    );
  }

  bool get useSmallerNavigationElements =>
      ref.watch(navigationSmallerNavigationElementsProvider);
  bool get showInfo => ref.watch(navigationShowInfoProvider);
}
