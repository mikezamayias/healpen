import 'package:flutter/material.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../utils/constants.dart';
import 'custom_list_tile/custom_list_tile.dart';

class CustomDialog extends StatelessWidget {
  final String titleString;
  final String contentString;
  final Color? backgroundColor;
  final List<CustomListTile> actions;

  const CustomDialog({
    super.key,
    required this.titleString,
    required this.contentString,
    this.backgroundColor,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      iconPadding: EdgeInsets.zero,
      insetPadding: EdgeInsets.zero,
      buttonPadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      titlePadding: EdgeInsets.all(gap),
      actionsPadding: EdgeInsets.only(
        left: gap,
        right: gap,
        bottom: gap,
      ),
      backgroundColor:
          backgroundColor ?? context.theme.colorScheme.primaryContainer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
      ),
      title: Container(
        width: 75.w,
        decoration: BoxDecoration(
          color: context.theme.colorScheme.background,
          borderRadius: BorderRadius.circular(radius - gap),
        ),
        padding: EdgeInsets.all(gap),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              titleString,
              style: context.theme.textTheme.headlineSmall!.copyWith(
                color: context.theme.colorScheme.onBackground,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: gap,
            ),
            Text(
              contentString,
              style: context.theme.textTheme.bodyLarge!.copyWith(
                color: context.theme.colorScheme.onBackground,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: actions,
    );
  }
}
