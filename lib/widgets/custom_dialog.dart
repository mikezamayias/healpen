import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../utils/constants.dart';
import 'custom_list_tile.dart';

class CustomDialog extends StatelessWidget {
  final String titleString;
  final String? contentString;
  final Widget? contentWidget;
  final Color? backgroundColor;
  final List<CustomListTile>? actions;

  const CustomDialog({
    super.key,
    required this.titleString,
    this.contentString,
    this.contentWidget,
    this.backgroundColor,
    this.actions,
  }) : assert(
          contentString == null || contentWidget == null,
          'Either contentString or contentWidget must be provided, '
          'but not both',
        );

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(
        sigmaX: gap * 2,
        sigmaY: gap * 2,
      ),
      child: AlertDialog(
        insetPadding: EdgeInsets.zero,
        titlePadding: EdgeInsets.all(gap),
        contentPadding: EdgeInsets.zero,
        buttonPadding: EdgeInsets.zero,
        actionsOverflowButtonSpacing: gap,
        actionsPadding: EdgeInsets.only(
          left: gap,
          right: gap,
          bottom: gap,
          top: contentString != null || contentWidget != null ? gap : 0,
        ),
        elevation: 0,
        backgroundColor:
            backgroundColor ?? context.theme.colorScheme.primaryContainer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
        title: Text(
          titleString,
          style: context.theme.textTheme.headlineSmall!.copyWith(
            color: context.theme.colorScheme.onPrimaryContainer,
          ),
          textAlign: TextAlign.start,
        ),
        content: contentString != null || contentWidget != null
            ? Container(
                width: 100.w - 2 * gap,
                padding: EdgeInsets.symmetric(horizontal: gap),
                child: Container(
                  decoration: BoxDecoration(
                    color: context.theme.colorScheme.background,
                    borderRadius: BorderRadius.circular(radius - gap),
                  ),
                  padding: EdgeInsets.all(gap),
                  child: contentString != null && contentWidget == null
                      ? Text(
                          contentString!,
                          style: context.theme.textTheme.bodyLarge!.copyWith(
                            color: context.theme.colorScheme.onBackground,
                          ),
                          textAlign: TextAlign.start,
                        )
                      : contentWidget,
                ),
              )
            : null,
        actions: actions != null && actions!.isNotEmpty
            ? [
                // add a sized box with width of gap between
                // the children
                for (int i = 0; i < actions!.length; i++) ...[
                  actions![i],
                  if (i != actions!.length - 1) SizedBox(width: gap),
                ]
              ]
            : [
                CustomListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: gap * 2),
                  cornerRadius: radius - gap,
                  responsiveWidth: true,
                  titleString: 'OK',
                  onTap: () => context.navigator.pop(),
                ),
              ],
      ),
    );
  }
}
