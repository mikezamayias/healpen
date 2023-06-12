import 'package:flutter/material.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../utils/constants.dart' as constants;
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
  final bool? selectableText;
  final bool? responsiveWidth;
  final Color? backgroundColor;
  final Color? textColor;

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
    this.trailingIconData,
    this.backgroundColor,
    this.textColor,
    this.selectableText = false,
    this.responsiveWidth = false,
  })  : assert(
          // there can only be at most one of title or titleString or none
          (titleString == null && title == null) ||
              (titleString != null && title == null) ||
              (titleString == null && title != null),
        ),
        assert(
          // there can only be at most one of subtitle or subtitleString or none
          (subtitleString == null && subtitle == null) ||
              (subtitleString != null && subtitle == null) ||
              (subtitleString == null && subtitle != null),
        ),
        assert(
          // there can only be at most one of leading or leadingIconData or none
          (leadingIconData == null && leading == null) ||
              (leadingIconData != null && leading == null) ||
              (leadingIconData == null && leading != null),
        ),
        assert(
          // there can only be at most one of trailing or trailingIconData or none
          (trailingIconData == null && trailing == null) ||
              (trailingIconData != null && trailing == null) ||
              (trailingIconData == null && trailing != null),
        ),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    var listTile = MyListTile(
      leading: leading,
      leadingIconData: leadingIconData,
      textColor: textColor,
      onTap: onTap,
      title: title,
      titleString: titleString,
      selectableText: selectableText,
      subtitle: subtitle,
      subtitleString: subtitleString,
      trailing: trailing,
      trailingIconData: trailingIconData,
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
          Radius.circular(constants.radius),
        ),
        child: switch (responsiveWidth) {
          false => IntrinsicWidth(child: listTile),
          _ => listTile,
        },
      ),
    );
  }
}

class MyListTile extends StatelessWidget {
  final Widget? leading;
  final IconData? leadingIconData;
  final Color? textColor;
  final GestureTapCallback? onTap;
  final Widget? title;
  final String? titleString;
  final bool? selectableText;
  final Widget? subtitle;
  final String? subtitleString;
  final Widget? trailing;
  final IconData? trailingIconData;

  const MyListTile({
    super.key,
    required this.leading,
    required this.leadingIconData,
    required this.textColor,
    required this.onTap,
    required this.title,
    required this.titleString,
    required this.selectableText,
    required this.subtitle,
    required this.subtitleString,
    required this.trailing,
    required this.trailingIconData,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      onLongPress: null,
      contentPadding: EdgeInsets.symmetric(
        horizontal: constants.gap * 2,
        vertical: constants.gap / 2,
      ),
      minLeadingWidth: 0,
      minVerticalPadding: constants.gap,
      horizontalTitleGap: constants.gap * 2,
      leading: leading != null || leadingIconData != null
          ? leading ??
              FaIcon(
                leadingIconData!,
                color: textColor ??
                    (onTap == null
                        ? context.theme.colorScheme.onSurfaceVariant
                        : context.theme.colorScheme.onPrimary),
                size: context.theme.textTheme.headlineMedium!.fontSize,
              )
          : null,
      title: title != null || titleString != null
          ? title ??
              (selectableText!
                  ? SelectableText(
                      titleString!,
                      style: context.theme.textTheme.titleLarge!.copyWith(
                        color: onTap == null
                            ? context.theme.colorScheme.onSurfaceVariant
                            : context.theme.colorScheme.onPrimary,
                      ),
                    )
                  : Text(
                      titleString!,
                      style: context.theme.textTheme.titleLarge!.copyWith(
                        color: textColor ??
                            (onTap == null
                                ? context.theme.colorScheme.onSurfaceVariant
                                : context.theme.colorScheme.onPrimary),
                      ),
                    ))
          : null,
      subtitle: subtitle != null || subtitleString != null
          ? subtitle != null
              ? Padding(
                  padding: EdgeInsets.only(top: gap),
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
                      style: context.theme.textTheme.titleLarge!.copyWith(
                        color: textColor ??
                            (onTap == null
                                ? context.theme.colorScheme.onSurfaceVariant
                                : context.theme.colorScheme.onPrimary),
                      ),
                    )
                  : Text(
                      subtitleString!,
                      style: context.theme.textTheme.titleLarge!.copyWith(
                        color: textColor ??
                            (onTap == null
                                ? context.theme.colorScheme.onSurfaceVariant
                                : context.theme.colorScheme.onPrimary),
                      ),
                    ))
          : null,
      trailing: trailing != null || trailingIconData != null
          ? trailing ??
              FaIcon(
                trailingIconData!,
                color: textColor ??
                    (onTap == null
                        ? context.theme.colorScheme.onSurfaceVariant
                        : context.theme.colorScheme.onPrimary),
                size: context.theme.textTheme.headlineMedium!.fontSize,
              )
          : null,
    );
  }
}
