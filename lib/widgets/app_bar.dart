import 'package:flutter/material.dart' hide AppBar, Page;
import 'package:flutter_screwdriver/flutter_screwdriver.dart';

class AppBar extends StatelessWidget {
  final String titleString;

  const AppBar({
    Key? key,
    required this.titleString,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      titleString,
      style: context.theme.textTheme.headlineSmall!.copyWith(
        color: context.theme.colorScheme.primary,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}
