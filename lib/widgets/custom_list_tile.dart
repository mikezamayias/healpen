import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sprung/sprung.dart';

import '../controllers/settings/preferences_controller.dart';
import '../providers/settings_providers.dart';
import '../utils/constants.dart';
import '../utils/helper_functions.dart';

class CustomListTile extends ConsumerWidget {
  final String? titleString;
  final String? explanationString;
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
  final bool? expandSubtitle;
  final bool? enableExplanationWrapper;
  final Color? backgroundColor;
  final Color? textColor;
  final double? cornerRadius;
  final EdgeInsetsGeometry? contentPadding;

  const CustomListTile({
    Key? key,
    this.titleString,
    this.explanationString,
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
    this.enableExplanationWrapper = false,
    this.expandSubtitle = false,
    this.cornerRadius,
    this.contentPadding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final padding = contentPadding ?? EdgeInsets.all(gap);
    final listTile = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: expandSubtitle! ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        if (leading != null ||
            leadingIconData != null ||
            title != null ||
            titleString != null ||
            trailing != null ||
            trailingIconData != null)
          Padding(
            padding: EdgeInsets.only(
              top: padding.vertical / 2,
              bottom: padding.vertical / 2,
              left: padding.horizontal / 2,
              right: padding.horizontal / 2,
            ),
            child: Row(
              children: [
                if (leading != null || leadingIconData != null)
                  Padding(
                    padding: (title != null || titleString != null)
                        ? padding.horizontal == 0
                            ? EdgeInsets.only(right: gap)
                            : EdgeInsets.only(right: padding.horizontal / 2)
                        : EdgeInsets.zero,
                    child: GestureDetector(
                      onTap: leadingOnTap,
                      child: Animate(
                        effects: showcaseLeadingIcon!
                            ? [
                                ShakeEffect(
                                  delay: 1.seconds,
                                  curve: Sprung.criticallyDamped,
                                  duration: 6.seconds,
                                  hz: 1,
                                  offset: const Offset(0, 3),
                                ),
                                ShakeEffect(
                                  delay: 2.seconds,
                                  curve: Sprung.criticallyDamped,
                                  duration: 6.seconds,
                                  hz: 1,
                                  offset: const Offset(3, 0),
                                ),
                              ]
                            : null,
                        onInit: showcaseLeadingIcon!
                            ? (_) async {
                                if (!PreferencesController
                                    .navigationShowInfoButtons.value) {
                                  await Future.delayed(
                                    1.seconds,
                                    HapticFeedback.vibrate,
                                  );
                                }
                              }
                            : null,
                        child: leading ??
                            FaIcon(
                              leadingIconData!,
                              color: textColor ??
                                  (leadingOnTap != null
                                      ? context.theme.colorScheme.primary
                                      : onTap == null
                                          ? context.theme.colorScheme
                                              .onSurfaceVariant
                                          : context
                                              .theme.colorScheme.onPrimary),
                              size:
                                  context.theme.textTheme.titleLarge!.fontSize,
                            ),
                      ),
                    ),
                  ),
                if (title != null || titleString != null)
                  Expanded(
                    child: title ??
                        Text(
                          titleString!,
                          style: context.theme.textTheme.titleLarge!.copyWith(
                            color: textColor ??
                                (onTap == null
                                    ? context.theme.colorScheme.onSurfaceVariant
                                    : context.theme.colorScheme.onPrimary),
                          ),
                        ),
                  ),
                if (trailing != null || trailingIconData != null)
                  Padding(
                    padding: (title != null || titleString != null)
                        ? EdgeInsets.only(left: padding.horizontal / 2)
                        : EdgeInsets.zero,
                    child: GestureDetector(
                      onTap: trailingOnTap,
                      child: trailing ??
                          (trailingOnTap != null
                              ? FaIcon(
                                  trailingIconData!,
                                  color: textColor ??
                                      context.theme.colorScheme.primary,
                                  size: context
                                      .theme.textTheme.titleLarge!.fontSize,
                                )
                              : FaIcon(
                                  trailingIconData!,
                                  color: textColor ??
                                      (onTap == null
                                          ? context.theme.colorScheme
                                              .onSurfaceVariant
                                          : context
                                              .theme.colorScheme.onPrimary),
                                  size: context
                                      .theme.textTheme.titleLarge!.fontSize,
                                )),
                    ),
                  ),
              ],
            ),
          )
        else
          SizedBox(
            height: padding.vertical / 2,
          ),
        if (subtitle != null || subtitleString != null)
          // if (expandSubtitle!)
            // Expanded(child: _buildSubtitle(context))
          // else
            Flexible(child: _buildSubtitle(context)),
        if (explanationString != null)
          Padding(
            padding: EdgeInsets.only(
              bottom: gap,
              left: gap,
              right: gap,
            ),
            child: Container(
              padding: enableExplanationWrapper! ? EdgeInsets.all(gap) : null,
              decoration: enableExplanationWrapper!
                  ? BoxDecoration(
                      color: context.theme.colorScheme.surface,
                      borderRadius: BorderRadius.all(
                        Radius.circular(radius - gap),
                      ),
                    )
                  : null,
              child: SelectableText(
                explanationString!,
                onTap: onTap,
                enableInteractiveSelection: selectableText!,
                style: TextStyle(
                  color: enableExplanationWrapper! || onTap == null
                      ? context.theme.colorScheme.onSurfaceVariant
                      : context.theme.colorScheme.onPrimary,
                ),
              ),
            ),
          ),
      ],
    );
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap != null
          ? () {
              vibrate(
                ref.watch(navigationEnableHapticFeedbackProvider),
                onTap!,
              );
            }
          : null,
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor ??
              (onTap == null
                  ? context.theme.colorScheme.surfaceVariant
                  : context.theme.colorScheme.primary),
          borderRadius: BorderRadius.all(
            Radius.circular(cornerRadius ?? radius),
          ),
        ),
        child: switch (responsiveWidth) {
          true => IntrinsicWidth(child: listTile),
          _ => listTile,
        },
      ),
    );
  }

  Padding _buildSubtitle(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: gap,
        left: gap,
        right: gap,
      ),
      child: Container(
        padding: enableSubtitleWrapper! ? EdgeInsets.all(gap) : null,
        decoration: enableSubtitleWrapper!
            ? BoxDecoration(
                color: context.theme.colorScheme.surface,
                borderRadius: BorderRadius.all(
                  Radius.circular(radius - gap),
                ),
              )
            : null,
        child: subtitle != null && subtitleString == null
            ? subtitle!
            : SelectableText(
                subtitleString!,
                onTap: onTap,
                enableInteractiveSelection: selectableText!,
                style: context.theme.textTheme.titleMedium!.copyWith(
                  color: enableSubtitleWrapper! || onTap == null
                      ? context.theme.colorScheme.onSurfaceVariant
                      : context.theme.colorScheme.onPrimary,
                ),
              ),
      ),
    );
  }
}
