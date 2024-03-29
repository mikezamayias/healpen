import 'package:flutter/material.dart' hide AppBar, Page;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../controllers/vibrate_controller.dart';
import '../providers/settings_providers.dart';
import '../utils/constants.dart';

class AppBar extends ConsumerWidget {
  final List<String> pathNames;
  final Color? backgroundColor;
  final bool? automaticallyImplyLeading;
  final VoidCallback? onBackButtonPressed;
  final Widget? trailingWidget;

  const AppBar({
    super.key,
    required this.pathNames,
    this.automaticallyImplyLeading = false,
    this.onBackButtonPressed,
    this.backgroundColor,
    this.trailingWidget,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showBackButton = ref.watch(navigationShowBackButtonProvider);
    final smallNavigationElements =
        ref.watch(navigationSmallerNavigationElementsProvider);
    final pathsLenth = smallNavigationElements ? 1 : pathNames.length;
    final appBarContent = AnimatedContainer(
      duration: standardDuration,
      curve: standardCurve,
      padding: showBackButton && pathsLenth < 3 && automaticallyImplyLeading!
          ? EdgeInsets.only(bottom: gap / 2)
          : EdgeInsets.zero,
      child: RichText(
        text: TextSpan(
          style: const TextStyle(),
          children: [
            for (int i = 0; i < pathsLenth; i++)
              WidgetSpan(
                child: Text(
                  smallNavigationElements
                      ? pathNames.last
                      : (i < pathNames.length - 1
                          ? '${pathNames[i]} / '
                          : pathNames[i]),
                  style: (i == pathsLenth)
                      ? context.theme.textTheme.titleLarge!.copyWith(
                          color: smallNavigationElements
                              ? context.theme.colorScheme.outline
                              : context.theme.colorScheme.onSurfaceVariant,
                        )
                      : context.theme.textTheme.headlineSmall!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: smallNavigationElements
                              ? context.theme.colorScheme.primary
                              : context.theme.colorScheme.onSurfaceVariant,
                        ),
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
          ],
        ),
      ),
    );

    final appBar = showBackButton && automaticallyImplyLeading!
        ? Stack(
            alignment: Alignment.topRight,
            children: <Widget>[
              Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: IconButton.filled(
                      padding: EdgeInsets.zero,
                      enableFeedback: true,
                      iconSize: context.theme.textTheme.titleLarge!.fontSize,
                      onPressed: () {
                        VibrateController().run(() {
                          if (onBackButtonPressed != null) {
                            onBackButtonPressed!();
                          }
                          context.navigator.pop();
                        });
                      },
                      color: context.theme.colorScheme.onPrimary,
                      icon: const FaIcon(FontAwesomeIcons.chevronLeft),
                    ),
                  ),
                  SizedBox(width: gap),
                  appBarContent,
                ],
              ),
              if (trailingWidget != null) ...[
                trailingWidget!,
              ],
            ],
          )
        : appBarContent;
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(top: gap),
        child: AnimatedContainer(
          duration: standardDuration,
          curve: standardCurve,
          padding: EdgeInsets.only(bottom: gap),
          child: AnimatedContainer(
            duration: standardDuration,
            curve: standardCurve,
            padding:
                smallNavigationElements ? EdgeInsets.zero : EdgeInsets.all(gap),
            decoration: smallNavigationElements
                ? const BoxDecoration()
                : BoxDecoration(
                    color: backgroundColor ??
                        context.theme.colorScheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(radius),
                  ),
            alignment: Alignment.bottomLeft,
            child: appBar,
          ),
        ),
      ),
    );
  }
}
