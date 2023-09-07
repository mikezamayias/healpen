import 'package:flutter/material.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../utils/constants.dart';

class CustomDialog extends StatelessWidget {
  final String titleString;
  final String? contentString;
  final Color? backgroundColor;
  final List<Widget> actions;

  const CustomDialog({
    super.key,
    required this.titleString,
    this.contentString,
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
      title: SizedBox(
        width: 75.w,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              titleString,
              style: context.theme.textTheme.headlineSmall!.copyWith(
                color: context.theme.colorScheme.onPrimaryContainer,
              ),
              textAlign: TextAlign.start,
            ),
            if (contentString != null) ...[
              SizedBox(height: gap),
              Container(
                padding: EdgeInsets.all(gap),
                decoration: BoxDecoration(
                  color: context.theme.colorScheme.background,
                  borderRadius: BorderRadius.circular(radius - gap),
                ),
                child: Text(
                  contentString!,
                  style: context.theme.textTheme.bodyLarge!.copyWith(
                    color: context.theme.colorScheme.onBackground,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
            ],
          ],
        ),
      ),
      actionsAlignment: MainAxisAlignment.end,
      actions: actions,
    );
  }
}
