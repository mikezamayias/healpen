import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../controllers/app_bar_controller.dart';
import '../../../providers/settings_providers.dart';
import '../../../utils/constants.dart';
import 'path_title.dart';
import 'path_title_with_leading.dart';

class SmallAppBar extends ConsumerWidget {
  const SmallAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final automaticallyImplyLeading =
        ref.watch(appBarControllerProvider).automaticallyImplyLeading;
    final showBackButton = ref.watch(navigationShowBackButtonProvider);

    return AnimatedCrossFade(
      duration: standardDuration,
      firstCurve: standardCurve,
      secondCurve: standardCurve,
      sizeCurve: standardCurve,
      reverseDuration: standardDuration,
      firstChild: const PathTitleWithLeading(),
      secondChild: const PathTitle(),
      crossFadeState: (showBackButton && automaticallyImplyLeading)
          ? CrossFadeState.showFirst
          : CrossFadeState.showSecond,
    );
  }
}
