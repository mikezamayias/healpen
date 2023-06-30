import 'package:flutter/material.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../utils/constants.dart';

class MyListTile extends StatelessWidget {
  final Widget? leading;
  final IconData? leadingIconData;
  final Color? textColor;
  final GestureTapCallback? onTap;
  final GestureTapCallback? trailingOnTap;
  final Widget? title;
  final String? titleString;
  final bool? selectableText;
  final Widget? subtitle;
  final String? subtitleString;
  final Widget? trailing;
  final IconData? trailingIconData;
  final EdgeInsetsGeometry? padding;

  const MyListTile({
    super.key,
    required this.leading,
    required this.leadingIconData,
    required this.textColor,
    required this.onTap,
    required this.trailingOnTap,
    required this.title,
    required this.titleString,
    required this.selectableText,
    required this.subtitle,
    required this.subtitleString,
    required this.trailing,
    required this.trailingIconData,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      onLongPress: null,
      contentPadding: padding ?? const EdgeInsets.all(12),
      minLeadingWidth: 0,
      minVerticalPadding: 0,
      horizontalTitleGap: 12,
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
                  padding: padding != null
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
  }
}
