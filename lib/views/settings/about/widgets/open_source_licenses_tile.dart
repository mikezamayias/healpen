import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../providers/settings_providers.dart';
import '../../../../utils/helper_functions.dart';
import '../../../../widgets/custom_list_tile.dart';
import '../../licenses/settings_licenses_view.dart';

class OpenSourceLicensesTile extends ConsumerStatefulWidget {
  const OpenSourceLicensesTile({
    super.key,
  });

  @override
  ConsumerState<OpenSourceLicensesTile> createState() =>
      _OpenSourceLicensesTileState();
}

class _OpenSourceLicensesTileState
    extends ConsumerState<OpenSourceLicensesTile> {
  @override
  Widget build(BuildContext context) {
    return CustomListTile(
      useSmallerNavigationSetting: !useSmallerNavigationElements,
      titleString: 'Open Source Licenses',
      explanationString: showInfo
          ? 'View the licenses of the open source packages used.'
          : null,
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

  bool get useSmallerNavigationElements =>
      ref.watch(navigationSmallerNavigationElementsProvider);
  bool get showInfo => ref.watch(navigationShowInfoProvider);
}
