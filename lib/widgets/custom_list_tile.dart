import 'package:flutter/material.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
    this.trailingOnTap,
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
    var listTile = ListTile(
      dense: false,
      onLongPress: null,
      contentPadding: contentPadding ??
          EdgeInsets.symmetric(
            horizontal: gap * 2,
            vertical: gap,
          ),
      minLeadingWidth: 0,
      minVerticalPadding: 0,
      horizontalTitleGap: (contentPadding?.horizontal ?? 12) / 2,
      leading: leading != null || leadingIconData != null
          ? leading ??
              FaIcon(
                leadingIconData!,
                color: textColor ??
                    (onTap == null
                        ? context.theme.colorScheme.onSurfaceVariant
                        : context.theme.colorScheme.onPrimary),
                size: context.theme.textTheme.headlineSmall!.fontSize,
              )
          : null,
      title: title != null || titleString != null
          ? title ??
              Text(
                titleString!,
                style: context.theme.textTheme.titleLarge!.copyWith(
                  color: textColor ??
                      (onTap == null
                          ? context.theme.colorScheme.onSurfaceVariant
                          : context.theme.colorScheme.onPrimary),
                ),
              )
          : null,
      subtitle: subtitle != null || subtitleString != null
          ? subtitle != null
              ? Padding(
                  padding: contentPadding != null
                      ? const EdgeInsets.only(top: 8)
                      : EdgeInsets.only(top: gap),
                  child: Container(
                    padding: EdgeInsets.all(gap),
                    decoration: BoxDecoration(
                      color: context.theme.colorScheme.surface,
                      borderRadius: BorderRadius.all(
                        Radius.circular(radius - gap),
                      ),
                    ),
                    child: subtitle,
                  ),
                )
              : (selectableText!
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
                    ))
          : null,
      trailing: trailing != null || trailingIconData != null
          ? GestureDetector(
              onTap: trailingOnTap,
              child: trailing ??
                  (trailingOnTap != null
                      ? FaIcon(
                          trailingIconData!,
                          color: textColor ?? context.theme.colorScheme.primary,
                          size: context.theme.textTheme.headlineSmall!.fontSize,
                        )
                      : FaIcon(
                          trailingIconData!,
                          color: textColor ??
                              (onTap == null
                                  ? context.theme.colorScheme.onSurfaceVariant
                                  : context.theme.colorScheme.onPrimary),
                          size: context.theme.textTheme.headlineSmall!.fontSize,
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
