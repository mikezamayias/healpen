import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../providers/settings_providers.dart';
import '../../../../widgets/custom_list_tile.dart';
import '../../../../widgets/custom_snack_bar.dart';

class TermsOfServiceTile extends ConsumerWidget {
  const TermsOfServiceTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomListTile(
      useSmallerNavigationSetting:
          !ref.watch(navigationSmallerNavigationElementsProvider),
      enableExplanationWrapper: false,
      titleString: 'Terms of Service',
      explanationString: 'View the terms of service for this app.',
      leadingIconData: FontAwesomeIcons.fileContract,
      onTap: () {
        CustomSnackBar(
          SnackBarConfig(
            vibrate: ref.watch(navigationEnableHapticFeedbackProvider),
            smallNavigationElements:
                ref.watch(navigationSmallerNavigationElementsProvider),
            titleString1: 'To be implemented.',
            leadingIconData1: FontAwesomeIcons.triangleExclamation,
          ),
        ).showSnackBar(context);
      },
    );
  }
}
