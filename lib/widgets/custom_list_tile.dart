import 'package:flutter/material.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:simple_gesture_detector/simple_gesture_detector.dart';

import '../utils/constants.dart';

class CustomListTile extends StatelessWidget {
  final String? titleString;
  final String? subtitleString;
  final Widget? title;
  final Widget? subtitle;
  final Widget? leading;
  final IconData? leadingIconData;
  final IconData? trailingIconData;
  final Widget? trailing;
  final GestureTapCallback? onTap;
  final GestureTapCallback? onLongPress;
  final GestureTapCallback? trailingOnTap;
  final GestureTapCallback? leadingOnTap;
  final Function(SwipeDirection)? onHorizontalSwipe;
  final Function(SwipeDirection)? onVerticalSwipe;
  final bool? selectableText;
  final bool? responsiveWidth;
  final Color? backgroundColor;
  final Color? textColor;
  final double? cornerRadius;
  final EdgeInsetsGeometry? contentPadding;

  const CustomListTile({
    Key? key,
    this.titleString,
    this.subtitleString,
    this.leadingIconData,
    this.trailing,
    this.leading,
    this.subtitle,
    this.title,
    this.onTap,
    this.onLongPress,
    this.onHorizontalSwipe,
    this.onVerticalSwipe,
    this.trailingOnTap,
    this.leadingOnTap,
    this.trailingIconData,
    this.backgroundColor,
    this.textColor,
    this.selectableText = false,
    this.responsiveWidth = false,
    this.cornerRadius,
    this.contentPadding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final padding = contentPadding ?? EdgeInsets.all(gap * 2);
    return SimpleGestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      onLongPress: onLongPress,
      onHorizontalSwipe: onHorizontalSwipe,
      onVerticalSwipe: onVerticalSwipe,
      child: PhysicalModel(
        color: backgroundColor ??
            (onTap == null
                ? context.theme.colorScheme.surfaceVariant
                : context.theme.colorScheme.primary),
        borderRadius: BorderRadius.all(
          Radius.circular(cornerRadius ?? radius),
        ),
        child: Padding(
          padding: padding,
          child: Row(
            mainAxisSize:
                responsiveWidth! ? MainAxisSize.min : MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              if (leading != null || leadingIconData != null) ...[
                leading ??
                    SimpleGestureDetector(
                      onTap: leadingOnTap,
                      child: FaIcon(
                        leadingIconData!,
                        color: textColor ??
                            ((leadingOnTap != null || onTap != null)
                                ? context.theme.colorScheme.onPrimary
                                : context.theme.colorScheme.onSurfaceVariant),
                        size: context.theme.textTheme.headlineSmall!.fontSize,
                      ),
                    ),
                SizedBox(width: padding.horizontal / 2),
              ],
              if (title == null && titleString != null)
                Text(
                  titleString!,
                  style: context.theme.textTheme.titleLarge!.copyWith(
                    color: textColor ??
                        (onTap == null
                            ? context.theme.colorScheme.onSurfaceVariant
                            : context.theme.colorScheme.onPrimary),
                  ),
                )
              else
                title!,
              // if (subtitle != null || subtitleString != null) ...[
              //   SizedBox(
              //     height:
              //     (contentPadding ?? EdgeInsets.all(gap)).vertical / 4,
              //   ),
              //   Container(
              //     decoration: BoxDecoration(
              //       color: backgroundColor ??
              //           context.theme.colorScheme.surface,
              //       borderRadius: BorderRadius.all(
              //         Radius.circular((cornerRadius ?? radius) - gap),
              //       ),
              //     ),
              //     child: Padding(
              //       padding: EdgeInsets.symmetric(
              //         horizontal: gap,
              //         vertical: gap / 2,
              //       ),
              //       child: subtitle ??
              //           SelectableText(
              //             subtitleString!,
              //             style:
              //             context.theme.textTheme.titleSmall!.copyWith(
              //               color: textColor ??
              //                   (onTap == null
              //                       ? context
              //                       .theme.colorScheme.onSurfaceVariant
              //                       : context.theme.colorScheme.onPrimary),
              //             ),
              //           ),
              //     ),
              //   ),
              // ],
              if (trailing != null || trailingIconData != null) ...[
                const Spacer(),
                trailing ??
                    SimpleGestureDetector(
                      onTap: trailingOnTap,
                      child: FaIcon(
                        trailingIconData!,
                        color: trailingOnTap == null
                            ? textColor ??
                                context.theme.colorScheme.onSurfaceVariant
                            : context.theme.colorScheme.primary,
                        size: context.theme.textTheme.headlineSmall!.fontSize,
                      ),
                    ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
