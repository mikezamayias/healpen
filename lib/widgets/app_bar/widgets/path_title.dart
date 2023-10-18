import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';

import '../../../controllers/app_bar_controller.dart';
import '../../../providers/settings_providers.dart';
import '../../../utils/constants.dart';

class PathTitle extends ConsumerStatefulWidget {
  const PathTitle({super.key});
  @override
  ConsumerState<PathTitle> createState() => _PathState();
}

class _PathState extends ConsumerState<PathTitle> {
  @override
  Widget build(BuildContext context) {
    final appBarController = ref.watch(appBarControllerProvider);
    return AnimatedPadding(
      duration: emphasizedDuration,
      curve: emphasizedCurve,
      padding: (ref.watch(navigationShowBackButtonProvider) &&
              appBarController.automaticallyImplyLeading)
          ? EdgeInsets.only(bottom: gap / 2)
          : EdgeInsets.zero,
      child: RichText(
        text: TextSpan(
          children: [
            for (int i = 0; i < appBarController.pathNames.length; i++)
              TextSpan(
                text: appBarController.getPathText(i),
                style: getPathTextStyle(i),
              ),
          ],
        ),
      ),
    );
  }

  TextStyle getPathTextStyle(int i) {
    final appBarController = ref.watch(appBarControllerProvider);
    return (i < appBarController.pathNames.length - 1)
        ? context.theme.textTheme.titleLarge!.copyWith(
            color: context.theme.colorScheme.outline,
          )
        : context.theme.textTheme.headlineSmall!.copyWith(
            color: context.theme.colorScheme.secondary,
          );
  }
}
