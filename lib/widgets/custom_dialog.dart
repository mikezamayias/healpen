import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../utils/constants.dart';
import 'custom_list_tile.dart';

class CustomDialog extends ConsumerStatefulWidget {
  final String titleString;
  final String? contentString;
  final Widget? contentWidget;
  final Color? backgroundColor;
  final Color? textColor;
  final bool? enableContentContainer;
  final List<CustomListTile>? actions;

  const CustomDialog({
    super.key,
    required this.titleString,
    this.contentString,
    this.contentWidget,
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
  ConsumerState<CustomDialog> createState() => _CustomDialogState();
}

class _CustomDialogState extends ConsumerState<CustomDialog> {
  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(
        sigmaX: gap * 2,
        sigmaY: gap * 2,
      ),
      child: AlertDialog(
        insetPadding: EdgeInsets.zero,
        titlePadding: widget.enableContentContainer!
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
          top: (widget.contentString != null || widget.contentWidget != null) &&
                  widget.enableContentContainer!
              ? gap
              : 0,
        ),
        elevation: 0,
        backgroundColor:
            widget.backgroundColor ?? context.theme.colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
        title: Text(
          widget.titleString,
          style: context.theme.textTheme.headlineSmall!.copyWith(
            color: widget.textColor ?? context.theme.colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.start,
        ),
        content: widget.contentString != null || widget.contentWidget != null
            ? Container(
                width: 100.w - 2 * gap,
                padding: widget.enableContentContainer!
                    ? EdgeInsets.symmetric(horizontal: gap)
                    : null,
                child: Container(
                  decoration: widget.enableContentContainer!
                      ? BoxDecoration(
                          color: context.theme.colorScheme.background,
                          borderRadius: BorderRadius.circular(radius - gap),
                        )
                      : null,
                  padding: widget.enableContentContainer!
                      ? EdgeInsets.all(gap)
                      : null,
                  child: widget.contentString != null &&
                          widget.contentWidget == null
                      ? Text(
                          widget.contentString!,
                          style: context.theme.textTheme.bodyLarge!.copyWith(
                            color: context.theme.colorScheme.onBackground,
                          ),
                          textAlign: TextAlign.start,
                        )
                      : widget.contentWidget,
                ),
              )
            : null,
        actions: widget.actions != null && widget.actions!.isNotEmpty
            ? [
                // add a sized box with width of gap between
                // the children
                for (int i = 0; i < widget.actions!.length; i++) ...[
                  widget.actions![i],
                  if (i != widget.actions!.length - 1) SizedBox(width: gap),
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
