import 'package:flutter/material.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';

import '../../utils/constants.dart';
import 'my_list_tile.dart';

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
    this.trailingIconData,
    this.backgroundColor,
    this.textColor,
    this.selectableText = false,
    this.responsiveWidth = false,
    this.cornerRadius,
    this.contentPadding,
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
      padding: contentPadding,
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
