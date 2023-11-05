import 'package:flutter/material.dart' hide AppBar, Page;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../providers/settings_providers.dart';
import '../utils/constants.dart';
import '../utils/helper_functions.dart';

class AppBar extends ConsumerWidget {
  final List<String> pathNames;
  final bool? automaticallyImplyLeading;
  final VoidCallback? onBackButtonPressed;

  const AppBar({
    super.key,
    required this.pathNames,
    this.automaticallyImplyLeading = false,
    this.onBackButtonPressed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showBackButton = ref.watch(navigationShowBackButtonProvider);
    final smallNavigationElements =
        ref.watch(navigationSmallerNavigationElementsProvider);
    final appBarContent = RichText(
      text: TextSpan(
        style: const TextStyle(),
        children: [
          for (int i = 0; i < pathNames.length; i++)
            WidgetSpan(
              child: Text(
                i < pathNames.length - 1
                    ? '${pathNames[i]} / '
                    : pathNames[i],
                style: (i < pathNames.length - 1)
                    ? context.theme.textTheme.titleLarge!.copyWith(
                        color: smallNavigationElements
                            ? context.theme.colorScheme.outline
                            : context.theme.colorScheme.onSurfaceVariant,
                      )
                    : context.theme.textTheme.headlineSmall!.copyWith(
                        color: smallNavigationElements
                            ? context.theme.colorScheme.secondary
                            : context.theme.colorScheme.onSurfaceVariant,
                      ),
                softWrap: true,
                overflow: TextOverflow.ellipsis,
              ),
            ),
        ],
      ),
    );

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
                color: context.theme.colorScheme.onPrimary,
                icon: const FaIcon(FontAwesomeIcons.chevronLeft),
              ),
              SizedBox(width: gap),
              Flexible(child: appBarContent),
            ],
          )
        : appBarContent;
    return AnimatedContainer(
      duration: standardDuration,
      curve: standardCurve,
      height: smallNavigationElements ? gap * 12 : gap * 15,
      padding: smallNavigationElements
          ? EdgeInsets.symmetric(vertical: gap)
          : EdgeInsets.all(gap),
      decoration: smallNavigationElements
          ? const BoxDecoration()
          : BoxDecoration(
              color: context.theme.colorScheme.surfaceVariant,
              borderRadius: BorderRadius.circular(radius),
            ),
      alignment: Alignment.bottomLeft,
      child: appBar,
    );
  }
}
