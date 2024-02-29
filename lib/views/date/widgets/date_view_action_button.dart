import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../utils/constants.dart';
import '../../../widgets/custom_list_tile.dart';

class DateViewActionButton extends ConsumerWidget {
  final String titleString;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Function()? onTap;

  const DateViewActionButton({
    super.key,
    required this.titleString,
    required this.onTap,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomListTile(
      cornerRadius: radius - gap,
      responsiveWidth: true,
      titleString: titleString,
      onTap: onTap,
      backgroundColor: backgroundColor,
      textColor: foregroundColor,
    );
  }
}
