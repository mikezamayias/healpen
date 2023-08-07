import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sprung/sprung.dart';

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
  final GestureTapCallback? trailingOnTap;
  final GestureTapCallback? leadingOnTap;
  final bool? selectableText;
  final bool? responsiveWidth;
  final bool? showcaseLeadingIcon;
  final bool? enableSubtitleWrapper;
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
    this.trailingOnTap,
    this.leadingOnTap,
    this.trailingIconData,
    this.backgroundColor,
    this.textColor,
    this.selectableText = false,
    this.responsiveWidth = false,
    this.showcaseLeadingIcon = false,
    this.enableSubtitleWrapper = true,
    this.cornerRadius,
    this.contentPadding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final padding = contentPadding ??
        EdgeInsets.symmetric(
          horizontal: gap * 2,
          vertical: gap,
        );
    final listTile = ListTile(
      dense: false,
      onTap: null,
      onLongPress: null,
      contentPadding: padding,
      minLeadingWidth: 0,
      minVerticalPadding: 0,
      horizontalTitleGap: padding.horizontal / 2,
      leading: leading != null || leadingIconData != null
          ? GestureDetector(
              onTap: leadingOnTap,
              child: Animate(
                effects: [
                  if (showcaseLeadingIcon!)
                    ShakeEffect(
                      delay: 1.seconds,
                      curve: Sprung.criticallyDamped,
                      duration: 6.seconds,
                      hz: 1,
                      offset: const Offset(0, 3),
                    ),
                ],
                child: leading ??
                    FaIcon(
                      leadingIconData!,
                      color: textColor ??
                          (leadingOnTap != null
                              ? context.theme.colorScheme.primary
                              : onTap == null
                                  ? context.theme.colorScheme.onSurfaceVariant
                                  : context.theme.colorScheme.onPrimary),
                      size: context.theme.textTheme.titleLarge!.fontSize,
                    ),
              ),
            )
          : null,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (title != null || titleString != null)
            title ??
                Text(
                  titleString!,
                  style: context.theme.textTheme.titleLarge!.copyWith(
                    color: textColor ??
                        (onTap == null
                            ? context.theme.colorScheme.onSurfaceVariant
                            : context.theme.colorScheme.onPrimary),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
          if (subtitle != null || subtitleString != null)
            subtitle != null && subtitleString == null
                ? Flexible(
                    child: Padding(
                      padding: EdgeInsets.only(top: padding.vertical / 2),
                      child: enableSubtitleWrapper!
                          ? Container(
                              padding: EdgeInsets.all(gap),
                              decoration: BoxDecoration(
                                color: context.theme.colorScheme.surface,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(radius - gap),
                                ),
                              ),
                              child: subtitle,
                            )
                          : subtitle!,
                    ),
                  )
                : selectableText!
                    ? SelectableText(
                        subtitleString!,
                        style: context.theme.textTheme.titleMedium!.copyWith(
                          color: textColor ??
                              (onTap == null
                                  ? context.theme.colorScheme.onSurfaceVariant
                                  : context.theme.colorScheme.onPrimary),
                        ),
                      )
                    : Text(
                        subtitleString!,
                        style: context.theme.textTheme.titleMedium!.copyWith(
                          color: textColor ??
                              (onTap == null
                                  ? context.theme.colorScheme.onSurfaceVariant
                                  : context.theme.colorScheme.onPrimary),
                        ),
                      ),
        ],
      ),
      trailing: trailing != null || trailingIconData != null
          ? GestureDetector(
              onTap: trailingOnTap,
              child: trailing ??
                  (trailingOnTap != null
                      ? FaIcon(
                          trailingIconData!,
                          color: textColor ?? context.theme.colorScheme.primary,
                          size: context.theme.textTheme.titleLarge!.fontSize,
                        )
                      : FaIcon(
                          trailingIconData!,
                          color: textColor ??
                              (onTap == null
                                  ? context.theme.colorScheme.onSurfaceVariant
                                  : context.theme.colorScheme.onPrimary),
                          size: context.theme.textTheme.titleLarge!.fontSize,
                        )),
            )
          : null,
    );
    return GestureDetector(
      onTap: onTap,
      child: PhysicalModel(
        color: backgroundColor ??
            (onTap == null
                ? context.theme.colorScheme.surfaceVariant
                : context.theme.colorScheme.primary),
        // shadowColor: context.theme.colorScheme.shadow,
        // elevation: onTap == null ? constants.gap : constants.gap / 2,
        borderRadius: BorderRadius.all(
          Radius.circular(cornerRadius ?? radius),
        ),
        child: switch (responsiveWidth) {
          true => IntrinsicWidth(child: listTile),
          _ => listTile,
        },
      ),
    );
  }
}
