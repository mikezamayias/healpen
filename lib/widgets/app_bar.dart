import 'package:flutter/material.dart' hide AppBar, Page;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../providers/settings_providers.dart';
import '../utils/constants.dart';

class AppBar extends ConsumerWidget {
  final List<String> pathNames;
  final bool? automaticallyImplyLeading;

  const AppBar({
    Key? key,
    required this.pathNames,
    this.automaticallyImplyLeading = false,
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
                      color: context.theme.colorScheme.outline,
                    )
                  : context.theme.textTheme.headlineSmall!.copyWith(
                      color: context.theme.colorScheme.secondary,
                    ),
            ),
        ],
      ),
    );
    return ref.watch(enableBackButtonProvider) &&
            automaticallyImplyLeading!
        ? Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton.filled(
                padding: EdgeInsets.zero,
                enableFeedback: true,
                iconSize: context.theme.textTheme.titleLarge!.fontSize,
                onPressed: context.navigator.pop,
                color: context.theme.colorScheme.onPrimary,
                icon: const FaIcon(FontAwesomeIcons.chevronLeft),
              ),
              SizedBox(width: gap),
              appBarContent,
            ],
          )
        : appBarContent;
  }
}
