import 'package:flutter/material.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';

import '../utils/constants.dart';
import 'custom_list_tile.dart';

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
      backgroundColor: context.theme.colorScheme.surfaceVariant,
      textColor: context.theme.colorScheme.onSurfaceVariant,
      cornerRadius: radius,
      titleString: durationTitle,
      leading: LinearProgressIndicator(
        value: value,
        color: context.theme.colorScheme.surfaceVariant,
      ),
    );
  }
}
