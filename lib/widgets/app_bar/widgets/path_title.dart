import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../controllers/app_bar_controller.dart';

class PathTitle extends ConsumerStatefulWidget {
  const PathTitle({super.key});
  @override
  ConsumerState<PathTitle> createState() => _PathTitleState();
}

class _PathTitleState extends ConsumerState<PathTitle> {
  @override
  Widget build(BuildContext context) {
    final pathNames = ref.watch(appBarControllerProvider).pathNames;
    return RichText(
      text: TextSpan(
        children: [
          for (int i = 0; i < pathNames.length; i++)
            TextSpan(
              text: getPathText(i, pathNames),
              style: getPathTextStyle(i, pathNames.length),
            ),
        ],
      ),
    );
  }

  String getPathText(int i, List<String> pathNames) {
    return i < pathNames.length - 1
        ? '${pathNames[i]} / '
        : pathNames.length != 1 && pathNames.length > 2
            ? '\n${pathNames[i]}'
            : pathNames[i];
  }

  TextStyle getPathTextStyle(int i, int length) {
    return (i < length - 1)
        ? Theme.of(context).textTheme.titleLarge!.copyWith(
              color: Theme.of(context).colorScheme.outline,
            )
        : Theme.of(context).textTheme.headlineSmall!.copyWith(
              color: Theme.of(context).colorScheme.secondary,
            );
  }
}
