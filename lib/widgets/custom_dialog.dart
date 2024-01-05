import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../utils/constants.dart';
import 'custom_list_tile.dart';

class CustomDialog extends ConsumerWidget {
  final String titleString;
  final String? contentString;
  final Widget? contentWidget;
  final Widget? trailingWidget;
  final Color? backgroundColor;
  final Color? textColor;
  final bool? enableContentContainer;
  final List<CustomListTile>? actions;

  const CustomDialog({
    super.key,
    required this.titleString,
    this.contentString,
    this.contentWidget,
    this.trailingWidget,
    this.backgroundColor,
    this.textColor,
    this.enableContentContainer = true,
    this.actions,
  }) : assert(
          contentString == null || contentWidget == null,
          'Either contentString or contentWidget must be provided, '
          'but not both',
        );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BackdropFilter(
      filter: ImageFilter.blur(
        sigmaX: gap * 2,
        sigmaY: gap * 2,
      ),
      child: AlertDialog(
        insetPadding: EdgeInsets.zero,
        titlePadding: enableContentContainer!
            ? EdgeInsets.all(gap)
            : EdgeInsets.only(
                left: gap,
                right: gap,
                top: gap,
              ),
        contentPadding: EdgeInsets.zero,
        buttonPadding: EdgeInsets.zero,
        actionsOverflowButtonSpacing: gap,
        actionsPadding: EdgeInsets.only(
          left: gap,
          right: gap,
          bottom: gap,
          top: (contentString != null || contentWidget != null) &&
                  enableContentContainer!
              ? gap
              : 0,
        ),
        elevation: 0,
        backgroundColor: backgroundColor ?? context.theme.colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              titleString,
              style: context.theme.textTheme.headlineSmall!.copyWith(
                color: textColor ?? context.theme.colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.start,
            ),
            if (trailingWidget != null) trailingWidget!,
          ],
        ),
        content: contentString != null || contentWidget != null
            ? Container(
                width: 100.w - 2 * gap,
                padding: enableContentContainer!
                    ? EdgeInsets.symmetric(horizontal: gap)
                    : null,
                child: Container(
                  decoration: enableContentContainer!
                      ? BoxDecoration(
                          color: context.theme.colorScheme.surfaceVariant,
                          borderRadius: BorderRadius.circular(radius - gap),
                        )
                      : null,
                  padding: enableContentContainer! ? EdgeInsets.all(gap) : null,
                  child: contentString != null && contentWidget == null
                      ? Text(
                          contentString!,
                          style: context.theme.textTheme.bodyLarge!.copyWith(
                            color: context.theme.colorScheme.onSurfaceVariant,
                          ),
                          textAlign: TextAlign.start,
                        )
                      : contentWidget,
                ),
              )
            : null,
        actionsAlignment: MainAxisAlignment.spaceBetween,
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
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: gap * 2,
                    vertical: gap,
                  ),
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
