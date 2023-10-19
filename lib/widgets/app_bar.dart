import 'package:flutter/material.dart' hide AppBar, Page;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../controllers/healpen/healpen_controller.dart';
import '../providers/settings_providers.dart';
import '../utils/constants.dart';
import '../utils/helper_functions.dart';

class AppBar extends ConsumerWidget {
  final List<String> pathNames;
  final bool? automaticallyImplyLeading;
  final VoidCallback? onBackButtonPressed;

  const AppBar({
    Key? key,
    required this.pathNames,
    this.automaticallyImplyLeading = false,
    this.onBackButtonPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appBarContent = RichText(
      text: TextSpan(
        children: [
          for (int i = 0; i < pathNames.length; i++)
            TextSpan(
              text: i < pathNames.length - 1
                  ? '${pathNames[i]} / '
                  : pathNames.length != 1 && pathNames.length > 2
                      ? '\n${pathNames[i]}'
                      : pathNames[i],
              style: (i < pathNames.length - 1)
                  ? context.theme.textTheme.titleLarge!.copyWith(
                      color: ref.watch(themeProvider).colorScheme.outline,
                    )
                  : context.theme.textTheme.headlineSmall!.copyWith(
                      color: ref.watch(themeProvider).colorScheme.secondary,
                    ),
            ),
        ],
      ),
    );
    final showBackButton = ref.watch(navigationShowBackButtonProvider);
    final appBar = showBackButton && automaticallyImplyLeading!
        ? Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton.filled(
                padding: EdgeInsets.zero,
                enableFeedback: true,
                iconSize: context.theme.textTheme.titleLarge!.fontSize,
                onPressed: () {
                  vibrate(ref.watch(navigationEnableHapticFeedbackProvider),
                      () {
                    if (onBackButtonPressed != null) {
                      onBackButtonPressed!();
                    } else {
                      context.navigator.pop();
                    }
                  });
                },
                color: ref.watch(themeProvider).colorScheme.onPrimary,
                icon: const FaIcon(FontAwesomeIcons.chevronLeft),
              ),
              SizedBox(width: gap),
              appBarContent,
            ],
          )
        : appBarContent;
    return Container(
      padding: EdgeInsets.all(gap),
      height: 42.h,
      decoration: BoxDecoration(
        color: ref.watch(themeProvider).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: ClipOval(
              child: Container(
                padding: EdgeInsets.all(gap * 2),
                color: ref.watch(themeProvider).colorScheme.secondary,
                child: FaIcon(
                  HealpenController()
                      .currentPageModel(ref
                          .watch(HealpenController().currentPageIndexProvider))
                      .icon,
                      color: ref.watch(themeProvider).colorScheme.onSecondary,
                  size: radius * 1.5,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: appBar,
          ),
        ],
      ),
    );
  }
}
