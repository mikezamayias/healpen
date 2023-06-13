import 'package:flutter/material.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';

import '../utils/constants.dart' as constants;
import 'custom_list_tile/custom_list_tile.dart';

class LoadingTile extends StatelessWidget {
  const LoadingTile({
    Key? key,
    required this.durationTitle,
    this.value,
  }) : super(key: key);

  final String durationTitle;
  final double? value;

  @override
  Widget build(BuildContext context) {
    return CustomListTile(
      backgroundColor: context.theme.colorScheme.background,
      titleString: durationTitle,
      subtitle: Container(
        height: context.theme.textTheme.headlineSmall!.fontSize!,
        alignment: Alignment.center,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(constants.radius),
          child: LinearProgressIndicator(
            value: value,
            color: context.theme.colorScheme.surfaceVariant,
          ),
        ),
      ),
    );
  }
}
