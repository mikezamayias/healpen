import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../providers/settings_providers.dart';
import '../../../../utils/helper_functions.dart';
import '../../../../widgets/custom_list_tile.dart';
import '../../licenses/settings_licenses_view.dart';

class OpenSourceLicensesTile extends ConsumerWidget {
  const OpenSourceLicensesTile({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomListTile(
      useSmallerNavigationSetting:
          !ref.watch(navigationSmallerNavigationElementsProvider),
      enableExplanationWrapper: false,
      titleString: 'Open Source Licenses',
      explanationString: 'View the licenses of the open source packages used.',
      leadingIconData: FontAwesomeIcons.code,
      onTap: () {
        pushWithAnimation(
          context: context,
          widget: const SettingsLicensesView(),
          dataCallback: null,
        );
      },
    );
  }
}
