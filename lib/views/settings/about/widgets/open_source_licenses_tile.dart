import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../providers/settings_providers.dart';
import '../../../../utils/constants.dart';
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
        context.navigator.push(
          PageRouteBuilder(
            transitionDuration: standardDuration,
            reverseTransitionDuration: standardDuration,
            pageBuilder: (
              context,
              animation,
              secondaryAnimation,
            ) {
              return const SettingsLicensesView();
            },
            transitionsBuilder: (
              context,
              animation,
              secondaryAnimation,
              child,
            ) {
              return FadeTransition(
                opacity: Tween<double>(
                  begin: -1,
                  end: 1,
                ).animate(animation),
                child: FadeTransition(
                  opacity: animation,
                  child: child,
                ),
              );
            },
          ),
        );
      },
    );
  }
}
