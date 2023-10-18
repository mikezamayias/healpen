import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../controllers/healpen/healpen_controller.dart';
import '../../../providers/settings_providers.dart';
import '../../../utils/constants.dart';

class PageIcon extends ConsumerWidget {
  const PageIcon({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Positioned(
      top: 0,
      right: 0,
      child: AnimatedOpacity(
        duration: emphasizedDuration,
        curve: emphasizedCurve,
        opacity: ref.watch(navigationShowAppBarTitleProvider) ? 1 : 0,
        child: Padding(
          padding: EdgeInsets.all(gap),
          child: ClipOval(
            child: Container(
              decoration: BoxDecoration(
                color: context.theme.colorScheme.secondary,
                borderRadius: BorderRadius.circular(radius),
              ),
              child: Padding(
                padding: EdgeInsets.all(gap * 1.5),
                child: FaIcon(
                  HealpenController()
                      .currentPageModel(ref
                          .watch(HealpenController().currentPageIndexProvider))
                      .icon,
                  color: context.theme.colorScheme.onSecondary,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
