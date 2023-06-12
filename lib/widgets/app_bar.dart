import 'package:flutter/material.dart' hide AppBar, Page;
import 'package:flutter_screwdriver/flutter_screwdriver.dart';

class AppBar extends StatelessWidget {
  final List<String> pathNames;

  const AppBar({Key? key, required this.pathNames}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
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
                  ? context.theme.textTheme.headlineSmall!.copyWith(
                      color: context.theme.colorScheme.outline,
                    )
                  : context.theme.textTheme.headlineMedium!.copyWith(
                      color: context.theme.colorScheme.primary,
                    ),
            ),
        ],
      ),
    );
  }
}
