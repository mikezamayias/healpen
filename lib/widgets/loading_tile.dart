import 'package:flutter/material.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';

import '../utils/constants.dart';
import 'custom_list_tile.dart';

class LoadingTile extends StatelessWidget {
  const LoadingTile({
    super.key,
    required this.durationTitle,
    this.value,
  });

  final String durationTitle;
  final double? value;

  @override
  Widget build(BuildContext context) {
    return CustomListTile(
      contentPadding: EdgeInsets.all(gap * 2),
      backgroundColor: context.theme.colorScheme.surfaceVariant,
      textColor: context.theme.colorScheme.onSurfaceVariant,
      cornerRadius: radius,
      titleString: durationTitle,
      leading: CircularProgressIndicator(value: value),
    );
  }
}
